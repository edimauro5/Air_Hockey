//
//  HasHitSound.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 20/07/22.
//

import Foundation
import RealityKit
import Combine

struct HitSoundComponent : Component
{
    var hitSoundSubscription : Cancellable?
    

}

protocol HasHitSound where Self: Entity { }

extension HasHitSound
{
    var hitSound : HitSoundComponent? {
        get {self.components[HitSoundComponent.self]}
        set {self.components[HitSoundComponent.self] = newValue}
    }
    
    
    
}

extension HasHitSound where Self: HasCollision & HasAudio & HasNetwork
{
    func addHitSound(){
        
        guard let scene = self.scene, let audio = self.audio , let network = self.network else {
            return
        }
        let nearbyService = network.networkSender
        let audioResource = audio.resource[0]
        
        self.hitSound?.hitSoundSubscription = scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
            guard let element = event.entityB as? HasPhysics else {return}
            if element.physicsBody?.mode == .dynamic
            {
                
                self.playAudio(audioResource)
                nearbyService.send(msg: "\(NearbyService.AUDIODELEGATE)#\(AudioResources.COLLISIONSOUND)")
            }
            
        }
        
    }
}


