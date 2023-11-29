//
//  FixedEntity.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 15/07/22.
//

import Foundation
import RealityKit

class FixedEntity : Entity, HasModel, HasAnchoring,HasCollision,IsRestricted{
    
    
    required init(restrictedComponent : RestrictionComponent) {
            super.init()
            
        
            
        self.components[CollisionComponent.self] = CollisionComponent(
                shapes: [.generateBox(size: [0.5,0.5,0.5])],
                mode: .trigger,
              filter: .sensor
            )
        
        self.components[ModelComponent.self] = ModelComponent(
                mesh: .generateBox(size: [0.5,0.5,0.5]),
                materials: [SimpleMaterial(
                    color: .red,
                    isMetallic: false)
                ]
            )
        self.components[RestrictionComponent.self] = restrictedComponent
        }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    convenience init(restrictedComponent : RestrictionComponent, position: SIMD3<Float>) {
            self.init(restrictedComponent : restrictedComponent)
            self.position = position
    }
    
    
    
    
    
}
