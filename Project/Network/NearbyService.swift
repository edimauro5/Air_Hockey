//
//  NearbyService.swift
//  FingerDragMultiplayer
//
//  Created by DarioNasti on 18/07/22.
//

import Foundation
import MultipeerConnectivity

class NearbyService: NSObject, ObservableObject,NetworkSender {
    
    var nearbyServiceDelegate : NearbyServiceDelegate?
    private var serviceType = "gt-nearby"
    @Published var peersFound : [String : IdentifiablePeer] = [:]
    @Published var isConnected : Bool = false
    @Published var isHost : Bool = false
    @Published var isClient : Bool = false
    var delegateDict : [String : NearbyServiceDelegate]
    private var clientId : MCPeerID?
    
    private let peerID = MCPeerID( displayName: UIDevice.current.name)
    private let nearbyServiceAdvertiser : MCNearbyServiceAdvertiser
    private let nearbyServiceBrowser : MCNearbyServiceBrowser
    
//    let peerID = MCPeerID(displayName: UIDevice.current.name)
//    let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
//    arView.scene.synchronizationService = try?
//    MultipeerConnectivityService(session: session )
    lazy var session : MCSession = {
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    override init() {
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        delegateDict = [:]
        super.init()
        nearbyServiceAdvertiser.delegate = self
        
        nearbyServiceBrowser.delegate = self
        nearbyServiceDelegate = self
        
    }
    
    convenience init(serviceType : String){
        self.init()
        self.serviceType = serviceType
    }
    
    convenience init(delegateDict : [String : NearbyServiceDelegate]){
        self.init()
        self.delegateDict = delegateDict
    }
    
    
    deinit{
        nearbyServiceAdvertiser.stopAdvertisingPeer()
        nearbyServiceBrowser.stopBrowsingForPeers()
    }
    
    func send(msg : String) {
        if let data = msg.data(using: .utf8), session.connectedPeers.count > 0 {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
    }
    
    func enterHostGame(host : MCPeerID)
    {
        nearbyServiceBrowser.invitePeer(host, to: session, withContext: nil, timeout: 10)
        isConnected = true
        isClient = true
    }
    
    func beginBrowsing()
    {
        peersFound = [:]
        nearbyServiceBrowser.startBrowsingForPeers()
        print("\(peerID.displayName) started browsing for peers...")
    }
    
    func beginHosting()
    {
        nearbyServiceAdvertiser.startAdvertisingPeer()
        print("\(peerID.displayName) started advertising peer...")
        isHost = true
        isConnected = true
    }
    
    static var POINTDELEGATE = "POINTS"
    static var AUDIODELEGATE = "AUDIO"
}

extension NearbyService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connecting :
            print("connecting: \(peerID.displayName)")
        case .connected:
            print("connected: \(peerID.displayName)")
        case .notConnected :
            print("not connected: \(peerID.displayName)")
            
        @unknown default:
            print("unknown state: \(state)")
            
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("did receive data: \(data)")
        if let msg = String(data: data, encoding: .utf8) {
            let prefixMessage = msg.split(separator: "#")
            print(msg)
            let prefix = String(prefixMessage[0])
            let message = String(prefixMessage[1])
            let delegate = self.delegateDict[prefix]
            DispatchQueue.main.async {
                delegate?.didReceive(msg: message)
            
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}

extension NearbyService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if clientId == nil{
            invitationHandler(true, session)
            clientId = peerID
            advertiser.stopAdvertisingPeer()
        }else{
            print("già connesso con un client")
        }
        
    
    }
}
    
extension NearbyService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        peersFound[peerID.displayName] = IdentifiablePeer(peer: peerID)
//        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 60)
		
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peersFound.removeValue(forKey: peerID.displayName)
    }
    
        
}


extension NearbyService : NearbyServiceDelegate
{
    func didReceive(msg: String) {
        print(msg)
//        let numeriStringati = msg.split(separator: ",")
//        self.punteggio1 = Int(numeriStringati[0])!
//        self.punteggio2 = Int(numeriStringati[1])!
    }
}









