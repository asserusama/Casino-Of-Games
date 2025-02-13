import Foundation
import Combine

class GameViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []

    @Published var isRing = true
    @Published var count = 1
    @Published var isCountdown = false
    @Published var isVote = false
    @Published var showAnswer = false
    @Published var score = 0
    @Published var ringPressedBy: String?
    @Published var currentQuestion: Question? // Replace with your actual Question type.

    // Additions
    @Published var votes: [String: Bool] = [:] // Tracks votes from peers (peerID: vote)
    @Published var totalPlayers: Int = 0 // Total connected players for vote synchronization

    private var timer: Timer?

    init() {
        NotificationCenter.default.publisher(for: .gameStateUpdated)
            .sink { [weak self] notification in
                if let userInfo = notification.userInfo as? [String: Any] {
                    self?.applyGameState(userInfo)
                }
            }
            .store(in: &cancellables)
    }

    func applyGameState(_ state: [String: Any]) {
        if let isRing = state["isRing"] as? Bool {
            self.isRing = isRing
        }
        if let isCountdown = state["isCountdown"] as? Bool {
            self.isCountdown = isCountdown
        }
        if let count = state["count"] as? Int {
            self.count = count
        }
        if let isVote = state["isVote"] as? Bool {
            self.isVote = isVote
        }
        if let showAnswer = state["showAnswer"] as? Bool {
            self.showAnswer = showAnswer
        }
        if let ringPressedBy = state["ringPressedBy"] as? String {
            self.ringPressedBy = ringPressedBy
        }
        if let score = state["score"] as? Int {
            self.score = score
        }

        // Handle votes
        if let votes = state["votes"] as? [String: Bool] {
            self.votes = votes
        }
        if let totalPlayers = state["totalPlayers"] as? Int {
            self.totalPlayers = totalPlayers
        }

        // Handle question synchronization
        if let type = state["type"] as? String, type == "newQuestion" {
            if let questionText = state["question"] as? String,
               let correctAnswer = state["correctAnswer"] as? String,
               let typeName = state["typeName"] as? String,
               let questionType = QuestionType.from(displayText: typeName) {
                self.currentQuestion = Question(
                    type: questionType,
                    question: questionText,
                    correctAnswer: correctAnswer,
                    options: state["options"] as? [String] // Use nil if no options are
                )
            }
        }
    }

    func broadcastGameState() {
        let state: [String: Any] = [
            "isRing": isRing,
            "isCountdown": isCountdown,
            "count": count,
            "isVote": isVote,
            "showAnswer": showAnswer,
            "ringPressedBy": ringPressedBy as Any,
            "score": score,
            "votes": votes,
            "totalPlayers": totalPlayers
        ]
        MultipeerConnectivityManager.shared.broadcastGameState(state)
    }

    func submitVote(_ isCorrect: Bool) {
        // Peer submits vote
        let peerID = MultipeerConnectivityManager.shared.myPeerID.displayName
        votes[peerID] = isCorrect
        broadcastGameState()
        checkVotesCompletion()
    }

    private func checkVotesCompletion() {
        if votes.count == totalPlayers {
            processVotes()
        }
    }

    private func processVotes() {
        // Aggregate votes
        let correctVotes = votes.values.filter { $0 }.count
        let incorrectVotes = votes.values.filter { !$0 }.count

        // Decide outcome
        if correctVotes > incorrectVotes {
            incrementScore()
        } else {
            decrementScore()
        }

        // Reset votes and proceed to the next round
        votes.removeAll()
        isVote = false
        showAnswer = false
        broadcastGameState()
    }

    func startCountdown() {
        timer?.invalidate()
        count = 3
        isCountdown = true
        broadcastGameState()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            if self.count > 0 {
                self.count -= 1
                self.broadcastGameState()
            } else {
                timer.invalidate()
                self.isCountdown = false
                self.showAnswer = true
                self.isVote = true
                self.broadcastGameState()
            }
        }
    }

    func incrementScore() {
        score += 1
        broadcastGameState()
    }

    func decrementScore() {
        score -= 1
        broadcastGameState()
    }

    func loadRandomQuestion() {
        // Generate a random question locally
        let randomType = QuestionType.allCases.randomElement() ?? .randomQuestion
        if let question = QuestionBank().questions[randomType]?.randomElement() {
            self.currentQuestion = question

            // Broadcast the selected question to all peers
            let questionData: [String: Any] = [
                "type": "newQuestion",
                "question": question.question,
                "correctAnswer": question.correctAnswer,
                "typeName": question.type.displayText,
                "options": question.options ?? []
            ]
            MultipeerConnectivityManager.shared.broadcastGameState(questionData)
        }
    }

    deinit {
        timer?.invalidate()
    }
}
