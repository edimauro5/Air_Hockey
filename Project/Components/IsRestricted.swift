//
//  IsRestricted.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 15/07/22.
//
//


import Foundation
import RealityKit
import Combine

struct RestrictionComponent : Component
{
    var oldPosition : SIMD3<Float>?
    var eventSubscription : Cancellable?
    var box : (x : SIMD2<Float>, y : SIMD2<Float> )
    

}

protocol IsRestricted where Self:Entity { }

extension IsRestricted
{
    var restriction : RestrictionComponent? {
        get {self.components[RestrictionComponent.self]}
        set {self.components[RestrictionComponent.self] = newValue}
    }
    
    
    
}

extension IsRestricted
{
    func addRestriction(){
        
        guard let scene = self.scene else {
            return
        }
        self.restriction?.oldPosition = self.transform.translation
        
        self.restriction?.eventSubscription = scene.subscribe(to: SceneEvents.Update.self) { event in
            if self.isValid()
            {
                self.restriction?.oldPosition = self.transform.translation
            } else
            {
//                print("nuova posizione :\(self.position) non è valida, ritorno alla posizione \(String(describing: self.restriction!.oldPosition))")
                self.transform.translation = self.restriction!.oldPosition!
            }
            
        }
        
    }
    
    func isValid() -> Bool
    {
        return (self.position.x <= self.restriction!.box.x.y && self.position.x >= self.restriction!.box.x.x)  && (self.position.z <= self.restriction!.box.y.y && self.position.z >= self.restriction!.box.y.x)
    }
}


