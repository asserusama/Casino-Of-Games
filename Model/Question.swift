import Foundation

enum QuestionType: CaseIterable {
    case reversedWords
    case capitals
    case songWord
    case movieScene
    case actorCatchphrase
    case randomQuestion

    var displayText: String {
        switch self {
        case .reversedWords: return "كلمات معكوسة"
        case .capitals: return "العواصم"
        case .songWord: return "كلمة حطها في أغنية"
        case .movieScene: return "مشهد من فيلم"
        case .actorCatchphrase: return "عبارة مشهورة"
        case .randomQuestion: return "أسئلة عشوائية"
        }
    }
}

extension QuestionType {
    static func from(displayText: String) -> QuestionType? {
        switch displayText {
        case "كلمات معكوسة": return .reversedWords
        case "العواصم": return .capitals
        case "كلمة حطها في أغنية": return .songWord
        case "مشهد من فيلم": return .movieScene
        case "عبارة مشهورة": return .actorCatchphrase
        case "أسئلة عشوائية": return .randomQuestion
        default: return nil
        }
    }
}

struct Question {
    let type: QuestionType
    let question: String
    let correctAnswer: String
    let options: [String]?
}
