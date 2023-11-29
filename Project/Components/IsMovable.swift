//
//  IsMovable.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 14/07/22.
//

import Foundation
import RealityKit

struct MovableComponent : Component{
    var view: ARView
}

protocol IsMovable where Self : HasCollision{}


extension IsMovable
{
    var movable : MovableComponent? {
        get {self.components[MovableComponent.self]}
        set {
            self.components[MovableComponent.self] = newValue
        }
    }
    func installMovement()
    {
        guard let movable = self.movable else {return}
        movable.view.installGestures([.translation], for: self)
    }
}
