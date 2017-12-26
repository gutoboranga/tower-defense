//
//  GameScene.swift
//  ewrsdfa
//
//  Created by Augusto Boranga on 26/12/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayScene: SKScene {
    
    var wave : (Int, Int) = (0,0)
    var state : [String : Any] = [:]
    
    override func sceneDidLoad() {
    }
    
    func play() -> [String : Any] {
        // Aqui vai acontecer a execução da wave, que só retornará quando acabar
        
        print (">> playing some wave")
        
        return state
    }
}
