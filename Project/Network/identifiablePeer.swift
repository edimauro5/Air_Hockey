//
//  identifiablePeer.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 19/07/22.
//

import Foundation
import MultipeerConnectivity

struct IdentifiablePeer : Identifiable
{
    var id: UUID = UUID()
    var peer : MCPeerID
}
