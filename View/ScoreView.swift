import SwiftUI

struct ScoreView: View {
    @Binding var score: Int
    @State private var hideScoreView = false
    @State private var navigateToGameView = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var viewModel: GameViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBG()
                VStack {
                    Text("السكور")
                        .font(.HeaderText)
                        .foregroundStyle(.white)
                        .padding()
                    Rectangle()
                        .frame(width: 320, height: 8)
                        .clipShape(.rect(cornerRadius: 20))
                        .foregroundStyle(.accent)
                    Spacer()
                    VStack {
                        ExtractedView(text: "اسر", score: score, image: "ic-image")
                        Spacer()
                    }
                    .padding(.top, 20)
                }
                .navigationBarBackButtonHidden()
                .onAppear {

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        hideScoreView = true
                        navigateToGameView = true 
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToGameView) {
                GameView()
            }
        }
    }
}

struct ExtractedView: View {
    var text = ""
    var score = 0
    var image = ""

    var body: some View {
        HStack {
            Text("\(score)")
                .padding(30)

            Spacer()

            Text("\(text)")
            Spacer()

            Image("\(image)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 55)
                .padding(30)
        }
        .frame(width: 330, height: 69)
        .multilineTextAlignment(.center)
        .background(Color.white)
        .foregroundStyle(.blueText)
        .clipShape(.rect(cornerRadius: 40))
        .font(.titleText)
    }
}
