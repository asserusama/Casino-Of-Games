import Foundation
import MultipeerConnectivity

extension MultipeerConnectivityManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        DispatchQueue.main.async {
            guard let roomName = info?["roomName"] else { return }
            if !self.availableRooms.contains(where: { $0.peerID == peerID }) {
                self.availableRooms.append((peerID: peerID, roomName: roomName))
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.availableRooms.removeAll { $0.peerID == peerID }
        }
    }
}
