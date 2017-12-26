//
//  GameScene.swift
//  ewrsdfa
//
//  Created by Augusto Boranga on 26/12/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit
import GameplayKit

class SetupScene: PlayScene {
    
    func addTower(tower: Tower) {
        let oldTowers = self.state["towers"] as! [Tower]
        let newTowers = oldTowers + [tower]
            
        self.state["towers"] = newTowers
    }
    
    func reloadMap() {
        
    }
}
