//
//  SoundDelegate.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 20/07/22.
//

import Foundation
import MultipeerConnectivity
import RealityKit


class SoundDelegate : NearbyServiceDelegate
{
    var session : MCSession
    
    init(session : MCSession)
    {
        self.session = session
    }
    
    func didReceive(msg: String) {
        print(msg)
        let audio = AudioResources.SOUNDDICT[msg]
        let entity = Entity()
        entity.playAudio(audio!)
    }
}
