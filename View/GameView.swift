import SwiftUI

struct GameView: View {
    @StateObject public var viewModel = GameViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBG()

                VStack {
                    if let question = viewModel.currentQuestion {
                        Text(question.type.displayText)
                            .font(.HeaderText)
                            .foregroundStyle(.white)
                            .padding()

                        Rectangle()
                            .frame(width: 320, height: 8)
                            .clipShape(.rect(cornerRadius: 20))
                            .foregroundStyle(.accent)

                        VStack {
                            if !viewModel.showAnswer {
                                Text(question.question)
                                    .frame(width: 330, height: 260)
                                    .multilineTextAlignment(.center)
                                    .background(Color.white)
                                    .foregroundStyle(.blueText)
                                    .clipShape(.rect(cornerRadius: 40))
                                    .font(.titleText)
                                    .padding(40)
                            } else {
                                Text(question.correctAnswer)
                                    .frame(width: 330, height: 260)
                                    .multilineTextAlignment(.center)
                                    .background(Color.white)
                                    .foregroundStyle(.blueText)
                                    .clipShape(.rect(cornerRadius: 40))
                                    .font(.titleText)
                                    .padding(40)
                            }

                            Spacer()

                            if viewModel.isRing {
                                Button(action: {
                                    viewModel.isRing = false
                                    viewModel.isCountdown = true
                                    viewModel.startCountdown()
                                    MultipeerConnectivityManager.shared.sendRingPressed()
                                }) {
                                    Image("ic-ring")
                                }
                                .padding(.bottom, 80)
                            } else if viewModel.isCountdown {
                                VStack {
                                    Text("اسر داس الاول") // Name of player
                                        .padding()
                                    Image("ic-image")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .padding()
                                    Text("\(viewModel.count) ثواني")
                                }
                                .font(.titleText)
                                .foregroundStyle(.white)
                                .padding(.bottom, 170)
                            } else if viewModel.isVote {
                                VStack {
                                    Image("ic-image")
                                    Text("تصويت")
                                        .font(.titleText)
                                        .foregroundStyle(.white)
                                        .padding()

                                    VStack {
                                        NavigationLink(
                                            destination: ScoreView(score: $viewModel.score)
                                        ) {
                                            Image("ic-correct")
                                        }
                                        .simultaneousGesture(
                                            TapGesture().onEnded {
                                                viewModel.incrementScore()
                                            }
                                        )

                                        NavigationLink(
                                            destination: ScoreView(score: $viewModel.score)
                                        ) {
                                            Image("ic-wrong")
                                        }
                                        .simultaneousGesture(
                                            TapGesture().onEnded {
                                                viewModel.decrementScore()
                                            }
                                        )
                                    }
                                    .font(.titleText)
                                    .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadRandomQuestion()
            viewModel.isRing = true
            viewModel.isVote = false
        }
        .navigationBarBackButtonHidden()
    }
}
