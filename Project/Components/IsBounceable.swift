//
//  IsBounceable.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 17/07/22.
//

import Foundation
import RealityKit
import Combine

struct BounceComponent : Component
{
    var bounceSubscriptionStart: Cancellable?
    var directionOfBounce : SIMD3<Float>
}

protocol IsBounceable where Self:Entity {}

extension IsBounceable
{
    var bounce : BounceComponent? {
        get {self.components[BounceComponent.self]}
        set {self.components[BounceComponent.self] = newValue}
    }
}

extension IsBounceable
{
    func addBounce()
    {
        guard let scene = self.scene, let bounce = self.bounce else {
            return
        }
        let directionOfBounce = bounce.directionOfBounce
        
        self.bounce?.bounceSubscriptionStart = scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
            
            guard let toBounce = event.entityB as? HasPhysics else {return}
            print(event.entityA.orientation)
            let currentVelocity = toBounce.physicsMotion!.linearVelocity
//            print("la vecchia velocità \(currentVelocity) è stata sostituita dalla nuova velocità \(newVelocity)")
//            toBounce.physicsMotion?.linearVelocity = newVelocity
//            toBounce.physicsBody?.mode = .dynamic
            toBounce.applyLinearImpulse(-directionOfBounce * currentVelocity * 2 * (toBounce.physicsBody?.massProperties.mass)!, relativeTo: toBounce.parent)
//            print(toBounce.physicsMotion?.linearVelocity)
            
            
        }
    }
}

