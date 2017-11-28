//
//  GameScene.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 27/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, MapDeglegate{
  
    var mapLoader : MapLoader!
    var spawn     : Spawn!
    
    
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        scene?.position = CGPoint(x: 0, y: 0)
        
        mapLoader = MapLoader()
        mapLoader.delegate = self
        mapLoader.loadMap()
        
    }
    
    override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        spawn.startRound()
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
    
    //Mark - MapLoader Delegate
    
    func nodeForMatrix(node: SKSpriteNode) {
        scene?.addChild(node)
    }
    
    func spawnner(_ spawn: Spawn) {
        self.spawn = spawn
    }

}


