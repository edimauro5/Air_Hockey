//
//  IsGoal.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 14/07/22.
//

import Foundation
import RealityKit
import Combine

struct GoalComponent : Component
{
    var goalSubscription : Cancellable?
    var pointTracker : PointsViewModel
    var player : Int
    var arena : Arena

}

protocol IsGoal { }

extension IsGoal where Self: Entity
{
    var goal : GoalComponent? {
        get {self.components[GoalComponent.self]}
        set {self.components[GoalComponent.self] = newValue}
    }
    
    
    
}

extension IsGoal where Self: HasCollision & HasAudio & HasNetwork
{
    func addGoalEvent(){
        
        guard let scene = self.scene, let goal = self.goal , let audio = self.audio , let network = self.network else {
            return
        }
        let nearbyService = network.networkSender
        let audioResource = audio.resource[0]
        let pointTracker = goal.pointTracker
        
        self.goal?.goalSubscription = scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
            if event.entityB == self.goal?.arena.dischetto
            {
                self.goal?.arena.resetDischetto()
                
                
                if goal.player == 1
                {
                    pointTracker.punteggioGiocatore1 += 1
                }
                else if goal.player == 2
                {
                    pointTracker.punteggioGiocatore2 += 1
                }
                self.playAudio(audioResource)
                nearbyService.send(msg: "\(NearbyService.POINTDELEGATE)#\(pointTracker.punteggioGiocatore1),\(pointTracker.punteggioGiocatore2)")
                nearbyService.send(msg: "\(NearbyService.AUDIODELEGATE)#\(AudioResources.GOALSOUNDCHEERING)")
            }
            
        }
        
    }
}


