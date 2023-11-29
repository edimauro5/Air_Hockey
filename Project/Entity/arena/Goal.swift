//
//  Goal.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 14/07/22.
//

import Foundation
import RealityKit
import SwiftUI
import Combine

class GoalEntity : Entity, HasModel, HasAnchoring, HasCollision,IsGoal, HasAudio,HasNetwork{
    
    
    required init(goalComponent : GoalComponent,mesh : MeshResource,transform : Transform,audio : AudioComponent,network : NetworkComponent) {
            super.init()
            
        var material = SimpleMaterial()
        material.baseColor = MaterialColorParameter.color(
            UIColor(red: 0, green: 1, blue: 0, alpha: 0.60)
          )
        self.model = ModelComponent(mesh: mesh, materials: [material])
        self.components[CollisionComponent.self] = CollisionComponent(
            shapes: [.generateConvex(from: mesh)],
                mode: .trigger,
              filter: .sensor
            )
            
//        self.components[ModelComponent.self] = ModelComponent(
//            mesh: mesh,
//                materials: [SimpleMaterial(
//                    color: .green,
//                    isMetallic: false)
//                ]
//            )
        
        self.components[GoalComponent.self] = goalComponent
        self.audio = audio
        self.network = network
        self.transform = transform
        }
    
    required init() {
        super.init()
    }
    
    
    
    
    
    
}
