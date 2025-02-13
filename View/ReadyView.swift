import SwiftUI
import UIKit

struct ReadyView: View {
    @State private var namePicturePopUp = false
    @State private var playerName = ""
    @State private var playerPicture: UIImage? = nil
    @FocusState private var isFocused: Bool
    @State private var showCamera = false
    @ObservedObject var connectivityManager = MultipeerConnectivityManager.shared

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBG()
                Image("bg-decoration").ignoresSafeArea()

                VStack {
                    Text("استعد")
                        .font(.HeaderText)
                        .foregroundStyle(.white)
                        .padding()

                    Rectangle()
                        .frame(width: 320, height: 8)
                        .clipShape(.rect(cornerRadius: 20))
                        .foregroundStyle(.accent)

                    Spacer()

                    VStack {
                        Text("""
                        اللعبة متقسمة إلى ٦ أسئلة:

                        - كلمات معكوسة  
                        - عواصم البلاد  
                        - كلمة حطها في أغنية  
                        - مشهد من فيلم  
                        - مين الممثل صاحب الإفيه  
                        - اختيارات  

                        اللي هيعرف الإجابة الأول 
                        ويلحق يدوس على الجرس له الحق في الإجابة

                        لو إجابته صح بياخد +1 
                        ولو إجابته غلط بياخد -1
                        """)
                    }
                    .frame(width: 340, height: 500)
                    .multilineTextAlignment(.center)
                    .background(Color.white)
                    .foregroundStyle(.blueText)
                    .clipShape(.rect(cornerRadius: 40))
                    .font(.JoinText)
                    .padding(.bottom, 120)
                }

                Button(action: { namePicturePopUp = true }) {
                    Image("ic-next")
                }
                .padding(.top, 580)

                if namePicturePopUp {
                    Color.black.opacity(0.7).ignoresSafeArea()

                    VStack(alignment: .center) {
                        HStack {
                            Text("عرف نفسك")
                                .font(.titleText)
                                .foregroundStyle(.blueText)
                                .padding(40)
                            Button(action: { self.namePicturePopUp = false }) {
                                Image("ic-close")
                            }
                        }
                        HStack {
                            TextField("عادل امام", text: $playerName)
                                .frame(width: 180, alignment: .trailing)
                                .font(.subTitleText)
                                .foregroundStyle(.blueText)
                                .textFieldStyle(.roundedBorder)
                                .focused($isFocused)
                            Text("اسمك؟")
                                .font(.subTitleText)
                                .foregroundStyle(.blueText)
                        }
                        HStack(spacing: 50) {
                            Button(action: {
                                showCamera = true
                            }) {
                                Image(systemName: "camera.circle.fill")
                                    .font(.system(size: 40))
                            }
                            Text("صوره روشه")
                                .font(.subTitleText)
                                .foregroundStyle(.blueText)
                                .padding(.leading, 60)
                        }
                        Button(action: {
                            if playerName.isEmpty {
                                isFocused = true
                            } else {
                                MultipeerConnectivityManager.shared.sendPlayerInfo(name: playerName, photo: playerPicture ?? UIImage())
                                MultipeerConnectivityManager.shared.sendReadyStatus()
                            }
                        }) {
                            Image("ic-ready")
                        }
                        .disabled(connectivityManager.readyPlayers.contains(connectivityManager.myPeerID.displayName))
                    }
                    .frame(width: 330, height: 330)
                    .background(Color.white)
                    .cornerRadius(40)
                    .shadow(radius: 20)
                    .sheet(isPresented: $showCamera) {
                        ImagePicker(sourceType: .camera, selectedImage: $playerPicture)
                    }
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { connectivityManager.allPlayersReady },
                set: { _ in }
            )) {
                GameView()
            }
            .navigationBarBackButtonHidden()
        }
    }
}
