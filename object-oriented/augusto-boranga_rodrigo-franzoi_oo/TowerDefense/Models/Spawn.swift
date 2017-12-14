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
    
    private let enemiesDelay = 1.0
    private var enemiesLvl : [[Int]]
    private var currentLevel    = -1
    private var enemiesToSpawn = 0
    
    private var enemiesAlive : NSMutableArray = NSMutableArray()
    private var state : GameStateMachine
    
    public var delegate : SpawnDelegate!
    
    init(position: CGPoint, code: Int, size: CGSize, enemiesLvl: [[Int]]) {
        
        self.state = .idle
        self.enemiesLvl = enemiesLvl
        
        let txt = SKTexture(imageNamed: code.description)
        super.init(texture: txt, color: .clear, size: size)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.name = "Spawn"
        self.position = position
        self.zPosition = 3
    }
    
    func startRound() {
        currentLevel += 1
        if currentLevel < enemiesLvl.count {
            enemiesToSpawn = enemiesLvl[currentLevel].count
            spawnEnemies(of: currentLevel)
        }
    }
    
    func spawnEnemies(of level: Int) {
        spawnEnemy(enemiesLvl[level])
    }
    
    func removeEnemy(enemy: Enemy) {
        self.enemiesAlive.remove(enemy)
        enemy.removeFromParent()
        if self.enemiesAlive.count == 0 && self.enemiesToSpawn <= 0 {
            self.delegate.endLevel()
        }
    }
    
    func spawnEnemy(_ enemies: [Int]) {
        
        self.enemiesToSpawn -= 1
        
        if let enemy = enemies.first {
            switch enemy {
            case 1:
                let enemy = FrogEnemy(position: self.position, life: 10, directions: mapDirections)
                self.delegate.addEnemy(enemyNode: enemy)
                self.enemiesAlive.add(enemy)
            case 2:
                let enemy = SpiderEnemy(position: self.position, life: 10, directions: mapDirections)
                self.delegate.addEnemy(enemyNode: enemy)
                self.enemiesAlive.add(enemy)
            case 3:
                let enemy = AstronautEnemy(position: self.position, life: 10, directions: mapDirections)
                self.delegate.addEnemy(enemyNode: enemy)
                self.enemiesAlive.add(enemy)
            case 4:
                let enemy = RoverEnemy(position: self.position, life: 10, directions: mapDirections)
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
    
    public func getCurrentLevel() -> Int {
        return currentLevel + 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
