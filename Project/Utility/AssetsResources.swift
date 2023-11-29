//
//  AssetsResources.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 20/07/22.
//

import Foundation
import RealityKit


class AssetsRsources
{
    static var tavolo : ModelEntity = {
        let scene = try! Assets.loadTavolo()
        let entity = scene.findEntity(named: "default")!
        return entity as! ModelEntity
        
    }()
    
    static var piattino : Entity =
    {
        let scene = try! Assets.loadPiattino()
        let entity = scene.findEntity(named: "piattino")!
        return entity
        
    }()
    
    static var dischetto : Entity =
    {
        let scene = try! Assets.loadDischetto()
        let entity = scene.findEntity(named: "dischetto")!
        print(scene)
        return entity
        
    }()
}
