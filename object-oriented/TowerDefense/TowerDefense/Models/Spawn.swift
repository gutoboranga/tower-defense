//
//  Spawn.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 27/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

class Spawn: SKSpriteNode {
    
    let enemiesLvl = [[1,1,1,1], [1,1,1,1], [1,1,1,1,1,1,1,1,1,1]]
    
    var atualLevel    = -1
    
    init(position: CGPoint, code: Int, size: CGSize) {
        let txt = SKTexture(imageNamed: code.description)
        
        super.init(texture: txt, color: .clear, size: size)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.name = "Spawn"
        self.position = position
        self.zPosition = 3
    }
    
    func startRound() {
        atualLevel += 1
        if atualLevel < enemiesLvl.count {
            spawnEnemies(of: atualLevel)
        }
    }
    
    func spawnEnemies(of level: Int) {
        spawnEnemy(enemiesLvl[level])
    }
    
    func spawnEnemy(_ enemies: [Int]) {
        if let enemy = enemies.first {
            switch enemy {
            case 1:
                let enemy = Enemy(name: "frog", position: self.position, life: 10)
                self.scene?.addChild(enemy)
                enemy.move()
            default:
                print("error")
            }
            
            let action = SKAction.wait(forDuration: 0.3)
            run(action, completion: {
                var newEnemies = enemies
                newEnemies.removeFirst()
                self.spawnEnemy(newEnemies)
            })
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
