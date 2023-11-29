//
//  HasNetwork.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 20/07/22.
//

import Foundation


import Foundation
import RealityKit
import Combine

struct NetworkComponent : Component
{
    var networkSender : NetworkSender

}

protocol HasNetwork where Self:Entity { }

extension HasNetwork
{
    var network : NetworkComponent? {
        get {self.components[NetworkComponent.self]}
        set {self.components[NetworkComponent.self] = newValue}
    }
    
    
    
}


