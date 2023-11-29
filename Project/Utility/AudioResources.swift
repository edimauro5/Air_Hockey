//
//  AudioResources.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 20/07/22.
//

import Foundation
import RealityKit


class AudioResources
{
    static var collisionSound : AudioResource = try! AudioFileResource.load(named: "hit.mp3", in: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: false)
    static var goalSound : AudioResource = try! AudioFileResource.load(named: "score.mp3", in: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: false)
    static var goalSoundCheering : AudioResource = try! AudioFileResource.load(named: "score-crowd.mp3", in: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: false)
    static var winGame : AudioResource = try! AudioFileResource.load(named: "win.mp3", in: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: false)
    static var lostGame : AudioResource = try! AudioFileResource.load(named: "lost.mp3", in: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: false)
    static var setDown : AudioResource = try! AudioFileResource.load(named: "setdown.mp3", in: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: false)
    static var background : AudioResource = try! AudioFileResource.load(named: "background.mp3", in: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: false)
    
    static var GOALSOUND : String = "GOALSOUND"
    static var COLLISIONSOUND : String = "COLLISIONSOUND"
    static var GOALSOUNDCHEERING : String = "GOALSOUNCHEERING"
    static var WINGAME : String = "WINGAME"
    static var LOSTGAME : String = "LOSTGAME"
    static var SETDOWN : String = "SETDOWN"
    static var BACKGROUND : String = "BACKGROUND"
    
    
    static var SOUNDDICT : [String : AudioResource] =
    [
        GOALSOUND : goalSound,
        COLLISIONSOUND : collisionSound,
        GOALSOUNDCHEERING : goalSoundCheering,
        WINGAME : winGame,
        LOSTGAME: lostGame,
        SETDOWN : setDown,
        BACKGROUND : background
    ]
    
    
    
    
    
}
