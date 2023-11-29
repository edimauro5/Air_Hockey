//
//  Piattino.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 15/07/22.
//

import Foundation
import RealityKit


class Piattino : Entity, HasPhysics,HasCollision,HasAnchoring,HasModel,IsMovable,IsRestricted,HasAudio,HasNetwork,HasHitSound
{
    required init(modelComponent : ModelComponent,movableComponent : MovableComponent,tranform : Transform,restrictionComponent : RestrictionComponent,audioComponent : AudioComponent,network:NetworkComponent,hitSound:HitSoundComponent) {
        super.init()
        self.model = nil
        self.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .kinematic)
        self.physicsMotion = .init()
        self.collision = .init(shapes: [.generateSphere(radius: 0.03)])
        self.transform = tranform
        self.movable = movableComponent
        self.audio = audioComponent
        self.hitSound = hitSound
        self.network = network
        self.restriction = restrictionComponent
        let child = AssetsRsources.piattino.clone(recursive: true)
        child.transform.translation = .init(x: -0.105, y: -0.02, z: -0.315)
        child.transform.scale = .one * 0.35
        child.components[CollisionComponent.self] = nil
        let model : ModelEntity = child.findEntity(named: "default")! as! ModelEntity
        model.model?.materials = [SimpleMaterial(color: .orange, isMetallic: false)]
        print(" transform figlio \(child.transform)")
        print("posizione figlio \(child.position)")
        self.children.append(child)
        
        }
    
    required init() {
        super.init()
    }
    
//    static func makePiattino(entity : Entity, modelComponent : ModelComponent,movableComponent : MovableComponent,tranform : Transform,restrictionComponent : RestrictionComponent,audioComponent : AudioComponent,network:NetworkComponent,hitSound:HitSoundComponent) -> (Entity & HasPhysics & HasCollision & HasAnchoring & HasModel & IsMovable & IsRestricted & HasAudio & HasNetwork & HasHitSound)
//    {
//        entity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .kinematic)
//        entity.physicsMotion = .init()
//        entity.collision = .init(shapes: [.generateSphere(radius: 0.017)])
//        self.transform = tranform
//        self.movable = movableComponent
//        self.audio = audioComponent
//        self.hitSound = hitSound
//        self.network = network
//        self.restriction = restrictionComponent
//    }
}
