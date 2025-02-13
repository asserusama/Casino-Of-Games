import SwiftUI

struct JoinOrCreateView: View {
    @State private var createRoomPopUp = false
    @State private var joinRoomPopUp = false
    @State private var roomName = ""
    @State private var scoreLimit = 1
    @State private var navigateToReadyView: Bool = false
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBG()
                Image("bg-decoration")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 200)

                VStack {
                    Image("bg-sword")
                        .padding(.top, 120)

                    Text("جاهز؟")
                        .font(.titleText)
                        .foregroundStyle(.white)
                        .padding(.top, 90)

                    HStack(spacing: 20) {
                        Button(action: {
                            self.createRoomPopUp = true
                        }) {
                            VStack(spacing: -20) {
                                Image("ic-create")
                                Text("اعمل روم")
                                    .font(.JoinText)
                                    .foregroundStyle(.white)
                            }
                        }

                        Button(action: {
                            self.joinRoomPopUp = true
                            MultipeerConnectivityManager.shared.joinRoom()
                        }) {
                            VStack(spacing: -20) {
                                Image("ic-join")
                                Text("خش روم")
                                    .font(.JoinText)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .padding(60)
                }

                // Create Room Pop-Up
                if $createRoomPopUp.wrappedValue {
                    Color.black.opacity(0.7).ignoresSafeArea()
                    VStack(alignment: .trailing) {
                        HStack {
                            Text("اعمل روم")
                                .font(.titleText)
                                .foregroundStyle(.blueText)
                                .padding(55)
                            Button(action: { self.createRoomPopUp = false }) {
                                Image("ic-close")
                            }
                        }
                        HStack {
                            TextField("المظابيط", text: $roomName)
                                .frame(width: 180, alignment: .trailing)
                                .font(.subTitleText)
                                .foregroundStyle(.blueText)
                                .textFieldStyle(.roundedBorder)
                                .focused($isFocused)
                            Text("اسم الروم؟")
                                .font(.subTitleText)
                                .foregroundStyle(.blueText)
                        }
                        HStack {
                            Button(action: {
                                if scoreLimit > 1 { scoreLimit -= 1 }
                            }) {
                                Image("ic-sub")
                            }
                            Text("\(scoreLimit)")
                                .foregroundStyle(.blueText)
                                .padding(3)
                            Button(action: {
                                if scoreLimit < 10 { scoreLimit += 1 }
                            }) {
                                Image("ic-add")
                            }
                            Text("الجيم من كام نقطه؟")
                                .font(.subTitleText)
                                .foregroundStyle(.blueText)
                                .padding(.leading)
                        }
                        Button(action: {
                            if roomName.isEmpty {
                                isFocused = true
                            } else {
                                MultipeerConnectivityManager.shared.startHosting(roomName: roomName)
                                navigateToReadyView = true
                            }
                        }) {
                            Image("ic-bignext")
                        }
                        .navigationDestination(isPresented: $navigateToReadyView) {
                            ReadyView()}

                    }
                    .frame(width: 330, height: 330)
                    .background(Color.white)
                    .cornerRadius(40).shadow(radius: 20)
                }

                // Join Room Pop-Up
                if $joinRoomPopUp.wrappedValue {
                    Color.black.opacity(0.7).ignoresSafeArea()
                    VStack {
                        HStack {
                            Text("خش روم")
                                .font(.titleText)
                                .foregroundStyle(.blueText)
                                .padding(55)
                            Button(action: { joinRoomPopUp = false }) {
                                Image("ic-close")
                            }
                        }
                        Text("Available Rooms")
                            .font(.JoinText)
                            .foregroundStyle(.blueText)
                        ScrollView {
                            ForEach(MultipeerConnectivityManager.shared.availableRooms, id: \.peerID) { room in
                                Button(action: {
                                    MultipeerConnectivityManager.shared.joinSpecificRoom(peerID: room.peerID)
                                    joinRoomPopUp = false
                                    navigateToReadyView = true
                                }) {
                                    Text(room.roomName)
                                        .font(.subTitleText)
                                        .padding()
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(10)
                                        .foregroundStyle(.blueText)
                                }
                            }
                        }
                        .frame(maxHeight: 200)
                        Spacer()
                    }
                    .frame(width: 330, height: 330)
                    .background(Color.white)
                    .cornerRadius(40)
                    .shadow(radius: 20)
                    .navigationDestination(isPresented: $navigateToReadyView) {
                        ReadyView()}

                }
            }
                
            .navigationBarBackButtonHidden(true)
        }
    }
}

