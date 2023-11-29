//
//  PeerView.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 19/07/22.
//

import SwiftUI

struct PeerView: View {
    @EnvironmentObject var nearbyService : NearbyService
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack
        {
            
            List(nearbyService.peersFound.values.reversed())
            {
                peer in
                Button(action: {
                    nearbyService.enterHostGame(host: peer.peer)
                    presentationMode.wrappedValue.dismiss()
                }, label: {Text(peer.peer.displayName)})
            }
        }
    }
}

struct PeerView_Previews: PreviewProvider {
    static var previews: some View {
        PeerView()
    }
}
