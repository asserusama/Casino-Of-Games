import Foundation
import MultipeerConnectivity
import SwiftUI

class MultipeerConnectivityManager: NSObject, ObservableObject {
    static let shared = MultipeerConnectivityManager()

    private let serviceType = "Casino"
    public var myPeerID: MCPeerID
    public var session: MCSession
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?

    @Published var connectedPeers: [MCPeerID] = []
    @Published var readyPlayers: Set<String> = []
    @Published var roomName: String = ""
    @Published var playerName: String = ""
    @Published var playerPhoto: UIImage?
    @Published var isHost: Bool = false
    @Published var receivedData: [String: Any] = [:]
    @Published var allPlayersReady: Bool = false
    @Published var gameScores: [String: Int] = [:]
    @Published var availableRooms: [(peerID: MCPeerID, roomName: String)] = []

    override init() {
        self.myPeerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        self.session.delegate = self
    }

    func startHosting(roomName: String) {
        self.roomName = roomName
        self.isHost = true
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["roomName": roomName], serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }

    func joinRoom() {
        self.isHost = false
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }

    func joinSpecificRoom(peerID: MCPeerID) {
        browser?.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }

    func sendReadyStatus() {
        let data: [String: Any] = [
            "type": "ready",
            "peer": myPeerID.displayName
        ]
        print("Sending ready status for: \(myPeerID.displayName)")
        sendData(data)
    }

    func applyReceivedGameState(_ state: [String: Any]) {
        if let type = state["type"] as? String {
            switch type {
            case "ready":
                if let peer = state["peer"] as? String {
                    DispatchQueue.main.async {
                        self.readyPlayers.insert(peer)
                        self.checkIfAllPlayersReady()
                    }
                }
            case "playerInfo":
                if let peer = state["peer"] as? String,
                   let name = state["name"] as? String,
                   let photoBase64 = state["photo"] as? String,
                   let photoData = Data(base64Encoded: photoBase64),
                   let photo = UIImage(data: photoData) {
                    DispatchQueue.main.async {
                        print("Received player info: \(name) from \(peer)")
                    }
                }
            default:
                break
            }
        }
    }

    func sendPlayerInfo(name: String, photo: UIImage) {
        guard let imageData = photo.pngData() else { return }
        let base64Photo = imageData.base64EncodedString()
        let data: [String: Any] = [
            "type": "playerInfo",
            "peer": myPeerID.displayName,
            "name": name,
            "photo": base64Photo
        ]
        sendData(data)
    }

    func checkIfAllPlayersReady() {
        let expectedReadyCount = session.connectedPeers.count + 1
        DispatchQueue.main.async {
            self.allPlayersReady = self.readyPlayers.count == expectedReadyCount
        }
    }

    func sendData(_ data: [String: Any]) {
        guard !session.connectedPeers.isEmpty,
              let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed) else { return }
        do {
            try session.send(jsonData, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Error sending data: \(error.localizedDescription)")
        }
    }
}
