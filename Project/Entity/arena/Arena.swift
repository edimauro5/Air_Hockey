//
//  Arena.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 17/07/22.
//

import Foundation
import RealityKit


class Arena : Entity,HasAnchoring,HasModel
{
    var walls : [Wall] = []
    var dischetto : Dischetto = Dischetto()
    var piattini : [Piattino] = []
    var pavimento : Pavimento = Pavimento()
    var goals : [GoalEntity] = []
    var nearbyService : NearbyService?
    var tavolo : ModelEntity?
    
    required init(transformComponent : Transform,movableComponent : MovableComponent,isHost : Bool,nearbyService : NearbyService,pointTracker : PointsViewModel) {
        
        super.init()
        self.transform = transformComponent
        self.initzialize(movableComponent: movableComponent,isHost: isHost,nearbyService : nearbyService,pointTracker : pointTracker)
        
        
    }
    
     func initzialize(movableComponent : MovableComponent,isHost : Bool,nearbyService : NearbyService,pointTracker : PointsViewModel) {
        self.nearbyService = nearbyService
        self.tavolo = ModelEntity()
         self.tavolo!.model = .init(mesh: AssetsRsources.tavolo.model!.mesh, materials: [SimpleMaterial(color: .lightGray, isMetallic: false)])
        self.tavolo!.collision = nil
        self.tavolo!.scale = .one * 0.005
        walls.append(contentsOf: createWalls())
        self.dischetto = createDisco()
        self.pavimento = createPavimento()
        self.children.append(contentsOf: walls)
        self.children.append(pavimento)
        self.children.append(tavolo! )
        if isHost{
            self.piattini.append(createPiattino(movableComponent: movableComponent))
            self.children.append(dischetto)
            self.goals = createGoals(pointTracker : pointTracker)
            self.children.append(contentsOf: self.goals)
        }
        else{
            self.piattini.append(createPiattinoClient(movableComponent: movableComponent))
        }
        self.children.append(contentsOf: piattini)
        
    }
    
    required init() {
        super.init()
    }
    
    func activateChildren()
    {
        for piattino in piattini {
            piattino.installMovement()
            piattino.addRestriction()
            piattino.addHitSound()
        }
        for wall in walls
        {
            wall.addBounce()
            wall.addHitSound()
        }
        for goal in goals
        {
            goal.addGoalEvent()
            
        }
//        self.dischetto.addForce(.init(x: 50, y: 0, z: 0), relativeTo: self)
    }
    
    func createWalls() -> [Wall]
    {
        var walls : [Wall] = []
        for i in 0..<wallRotation.count
        {
            let transform = Transform(scale: .one, rotation: wallRotation[i], translation: wallPosition[i])
            let bounceComponent = BounceComponent(directionOfBounce: wallBounceDirection[i])
            let audioComponent = AudioComponent(resource: [AudioResources.collisionSound])
            let networkComponent = NetworkComponent(networkSender: nearbyService!)
            let hitSoundComponent = HitSoundComponent()
            
            let wall = Wall(transformComponent: transform, size: wallSize[i], bounceComponent:bounceComponent ,audioComponent: audioComponent,network: networkComponent,hitSound: hitSoundComponent)
            
            walls.append(wall)
        }
        
        return walls
    }
    
    func createPavimento() -> Pavimento
    {
        Pavimento(transformComponent: .init(scale: .one, rotation: .init(), translation: pavimentoPosition ),size: pavimentoSize )
    }
    
    func createPiattino(movableComponent: MovableComponent) -> Piattino
    {
        let modelComponent = ModelComponent(mesh: .generateSphere(radius: radiusPiattino), materials: [SimpleMaterial.init(color: .orange, isMetallic: false)])
        let transform = Transform(scale: .one , rotation: .init(), translation: piattinoPosition )
        let restrictionComponent = RestrictionComponent(box: (SIMD2<Float>(x: -pavimentoSize.x/2 + wallSize[0].z + radiusPiattino + radiusDischetto, y: pavimentoSize.x/2 - wallSize[0].z - radiusPiattino - radiusDischetto),SIMD2<Float>(x: -pavimentoSize.z/2 + wallSize[0].z + radiusPiattino + radiusDischetto, y: 0)))
        let audioComponent = AudioComponent(resource: [AudioResources.collisionSound])
        let networkComponent = NetworkComponent(networkSender: nearbyService!)
        let hitSoundComponent = HitSoundComponent()
        
        let piattino = Piattino(modelComponent: modelComponent, movableComponent: movableComponent, tranform: transform,restrictionComponent: restrictionComponent,audioComponent: audioComponent,network: networkComponent,hitSound: hitSoundComponent)
        
        return piattino
    }
    
    func createPiattinoClient(movableComponent: MovableComponent) -> Piattino
    {
        
        let modelComponent = ModelComponent(mesh: .generateSphere(radius: radiusPiattino), materials: [SimpleMaterial.init(color: .orange, isMetallic: false)])
        let transform = Transform(scale: .one , rotation: .init(), translation: piattinoPosition * SIMD3<Float>(x: 1, y: 1, z: -1))
        let restrictionComponent = RestrictionComponent(box: (SIMD2<Float>(x: -pavimentoSize.x/2 + wallSize[0].z + radiusPiattino + radiusDischetto, y: pavimentoSize.x/2 - wallSize[0].z - radiusPiattino - radiusDischetto),SIMD2<Float>(x:0, y:pavimentoSize.z/2 - wallSize[0].z - radiusPiattino + radiusDischetto)))
        let audioComponent = AudioComponent(resource: [AudioResources.collisionSound])
        let networkComponent = NetworkComponent(networkSender: nearbyService!)
        let hitSoundComponent = HitSoundComponent()
        
        let piattino = Piattino(modelComponent: modelComponent, movableComponent: movableComponent, tranform: transform,restrictionComponent: restrictionComponent,audioComponent: audioComponent,network: networkComponent,hitSound: hitSoundComponent)
        
        return piattino
    }
    
    func createDisco() -> Dischetto
    {
        return Dischetto(modelComponent: .init(mesh: .generateSphere(radius: radiusDischetto), materials: [SimpleMaterial(color: .yellow, isMetallic: false)]),transform: .init(scale: .one, rotation: .init(), translation:  dischettoPosition ))
    }
    
    func createGoals(pointTracker : PointsViewModel) -> [GoalEntity]
    {
        var result : [GoalEntity] = []
        var i = 1
        for position in goalPosition
        {
            let goalComponent = GoalComponent(pointTracker: pointTracker, player: i, arena: self)
            let transform = Transform(scale: .one, rotation: .init(), translation: position)
            let audio = AudioComponent(resource: [AudioResources.goalSoundCheering])
            let network = NetworkComponent(networkSender: nearbyService!)
            
            let goal = GoalEntity(goalComponent: goalComponent, mesh: .generateBox(size: goalSize), transform: transform,audio: audio,network: network)
            result.append(goal)
            i += 1
        }
        return result
    }
    
    func resetDischetto()
    {
        self.removeChild(self.dischetto)
        self.dischetto = createDisco()
        self.children.append(self.dischetto)
    }
    
    
    
    
    var size : SIMD3<Float> = .init(x: 0.75, y: 0.1, z: 1.3)
    var pavimentoSize : SIMD3<Float>{ get{ .init(x: size.x, y: size.y/2, z: size.z)}}
    var pavimentoPosition :SIMD3<Float> {get {.init(x: 0, y: -0.025, z: 0)}}
    var wallSize: [SIMD3<Float>] {get{
    [
        .init(x: size.x, y: size.y/2, z: size.y/2),
        .init(x: size.z, y: size.y/2, z: size.y/2),
        .init(x: size.x, y: size.y/2, z: size.y/2),
        .init(x: size.z, y: size.y/2, z: size.y/2)
    ]}}
    var wallPosition:
    [SIMD3<Float>] {get{
    [
        .init(x: 0, y: pavimentoPosition.y + pavimentoSize.y/2 + wallSize[0].y/2, z: -pavimentoSize.z/2 + wallSize[0].z/2),
        .init(x: pavimentoSize.x/2 - wallSize[1].z/2, y: pavimentoPosition.y + pavimentoSize.y/2 + wallSize[1].y/2, z: 0),
        .init(x: 0, y: pavimentoPosition.y + pavimentoSize.y/2 + wallSize[2].y/2, z: pavimentoSize.z/2 - wallSize[2].z/2),
        .init(x: -pavimentoSize.x/2 + wallSize[3].z/2, y: pavimentoPosition.y + pavimentoSize.y/2 + wallSize[3].y/2, z: 0)
        
    ]}}
    var wallRotation : [simd_quatf] {get{
    [
        .init(angle: 0, axis: .init(x: 0, y: 1, z: 0)),
        .init(angle: .pi/2, axis: .init(x: 0, y: 1, z: 0)),
        .init(angle: .pi, axis: .init(x: 0, y: 1, z: 0)),
        .init(angle: 3/2 * .pi, axis: .init(x: 0, y: 1, z: 0))
    ]}}
    var wallBounceDirection : [SIMD3<Float>] {get{
    [
        .init(x: 0, y: 0, z: 1),
        .init(x: 1, y: 0, z: 0),
        .init(x: 0, y: 0, z: 1),
        .init(x: 1, y: 0, z: 0)
    ]}}
    
    var radiusPiattino : Float {get{0.030}}
    var piattinoPosition : SIMD3<Float> {get{ .init(x: 0, y: pavimentoPosition.y + pavimentoSize.y/2 + radiusPiattino, z: wallPosition[0].z + wallSize[0].z/2 + radiusPiattino*3)}}
    var radiusDischetto : Float {get {0.015}}
    var dischettoPosition : SIMD3<Float> {get{ .init(x: 0, y: pavimentoPosition.y + pavimentoSize.y/2 + radiusDischetto, z: 0)}}
    
    var goalSize : SIMD3<Float> {
        get
        {
            .init(x: 0.2 * wallSize[0].x, y: wallSize[0].y/2, z: wallSize[0].z * 1.1)
        }
    }
    var goalPosition : [SIMD3<Float>] {
        get
        {
            [
                .init(x: 0, y:pavimentoPosition.y + pavimentoSize.y/2 + goalSize.y/2 , z: pavimentoSize.z/2 - goalSize.z/2),
                .init(x: 0, y: pavimentoPosition.y + pavimentoSize.y/2 + goalSize.y/2 , z: -pavimentoSize.z/2 + goalSize.z/2),
            ]
        }
    }
    
}

