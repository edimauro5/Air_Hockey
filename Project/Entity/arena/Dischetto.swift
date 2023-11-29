//
//  Dischetto.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 14/07/22.
//

import Foundation
import RealityKit


class Dischetto : Entity, HasPhysics,HasCollision,HasAnchoring,HasModel
{
    required init(modelComponent : ModelComponent,transform : Transform) {
        super.init()
        self.model = nil
        self.collision = .init(shapes: [.generateSphere(radius: 0.015)])
        self.transform = transform
        self.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(friction: 0, restitution: 1), mode: .dynamic)
        self.physicsMotion = .init()
        let child = AssetsRsources.dischetto.clone(recursive: true)
        child.transform.translation = .init(x: 0, y: 0, z: -0.225)
        child.transform.scale = .one * 0.25
        child.components[CollisionComponent.self] = nil
        let model : ModelEntity = child.findEntity(named: "default")! as! ModelEntity
        model.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
        self.children.append(child)
        }
    
    required init() {
        super.init()
    }
    
    
    
        
}

