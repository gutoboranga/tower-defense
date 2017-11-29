//
//  Spawn.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 27/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

protocol SpawnDelegate {
    func addEnemy(enemyNode: Enemy)
    func endLevel()
}

class Spawn: SKSpriteNode {
    
    private let enemiesDelay = 2.0
    private let enemiesLvl   = [[1,1,1,1], [1,1,1,1], [1,1,1,1,1,1,1,1,1,1], [1]]
    private var atualLevel   = -1
    
    private var enemiesAlive : NSMutableArray = NSMutableArray()
    private var state : GameStateMachine
    
    public var delegate : SpawnDelegate!
    
    init(position: CGPoint, code: Int, size: CGSize) {
        self.state = .idle
        
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
    
    func removeEnemy(enemy: Enemy) {
        self.enemiesAlive.remove(enemy)
        enemy.removeFromParent()
        if self.enemiesAlive.count == 0 {
            self.delegate.endLevel()
        }
    }
    
    func spawnEnemy(_ enemies: [Int]) {
        if let enemy = enemies.first {
            switch enemy {
            case 1:
                let enemy = Enemy(name: "frog", position: self.position, life: 10)
                self.delegate.addEnemy(enemyNode: enemy)
                self.enemiesAlive.add(enemy)
            default:
                print("error")
            }
            
            let action = SKAction.wait(forDuration: enemiesDelay)
            run(action, completion: {
                var newEnemies = enemies
                newEnemies.removeFirst()
                self.spawnEnemy(newEnemies)
            })
        }
    }
    
    public func setState(newState: GameStateMachine) {
        if state != newState {
            self.state = newState
            switch newState {
            case .idle:
                break
            case .playing:
                self.startRound()
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
