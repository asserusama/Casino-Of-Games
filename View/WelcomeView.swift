//
//  ContentView.swift
//  CasinoCardGame
//
//  Created by Asser on 29/11/2024.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack{
            ZStack {
                GradientBG()
                VStack{
                    Image("bg-question")
                        .padding(.bottom, 100)
                    VStack{
                        Text("كازينو الالعاب")
                            .font(Font.titleText)
                            .bold()
                            .foregroundStyle(Color("BlueText"))
                            .padding(.bottom, 5)
                        Text("اللعب و اكسب صحابك!")
                            .font(Font.subTitleText)
                            .foregroundStyle(Color("GraySubText"))

                    }
                    .frame(width: 330, height: 230)
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    }


                }
                NavigationLink(destination: JoinOrCreateView()){
                    Image("ic-next")


                }
                .padding(.top, 630)
            }

        }

    }
}

#Preview {
    WelcomeView()
}

struct GradientBG: View {
    var body: some View {
        LinearGradient(
            colors: [Color("BGCyan"), Color("BGBlue")],
            startPoint: .top,
            endPoint: .trailing
        )
        .ignoresSafeArea()

    }
}
