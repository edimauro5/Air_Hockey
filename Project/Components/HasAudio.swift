//
//  HasAudio.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 20/07/22.
//

import Foundation
import RealityKit
import Combine

struct AudioComponent : Component
{
    var resource : [AudioResource]

}

protocol HasAudio where Self:Entity { }

extension HasAudio
{
    var audio : AudioComponent? {
        get {self.components[AudioComponent.self]}
        set {self.components[AudioComponent.self] = newValue}
    }
    
    
    
}

