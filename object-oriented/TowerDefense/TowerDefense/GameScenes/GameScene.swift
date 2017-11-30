//
//  GameScene.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 27/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameStateMachine {
    case idle
    case playing
}

class GameScene: SKScene, MapDelegate, HudLayerDelegate, SpawnDelegate, TowerDelegate, SKPhysicsContactDelegate{
    
    private let xIniPos = 732.0
    private let yIniPos = 406.0
    
    private var mapLoader : MapLoader!
    private var spawn     : Spawn!
    private var castle    : Castle!
    private var hudLayer  : HudLayer!
    private var state     : GameStateMachine!
    
    private var usableGround : NSMutableArray = NSMutableArray()
    private var towers       : NSMutableArray = NSMutableArray()
    
    private var score : Int = 0
    private var coins : Int = 0
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        self.scene?.position = CGPoint(x: 0, y: 0)
        self.physicsWorld.contactDelegate = self
        
        self.mapLoader = MapLoader()
        self.mapLoader.delegate = self
        self.mapLoader.loadMap()
        
        self.hudLayer = HudLayer(texture: nil, color: .clear, size: size)
        self.hudLayer.delegate = self
        addChild(hudLayer)
        
        self.hudLayer.setScore(newScore: self.score)
        self.hudLayer.setCoins(newCoins: self.coins)
  
        self.setState(newState: .idle)
        //self.coins += coinsPerLevel[self.spawn.getCurrentLevel()]
        //self.hudLayer.setCoins(newCoins:  self.coins)
    }
    
    private func addTower(in ground: Ground) {
        if coins >= 50 {
            if let button = hudLayer?.selectedButton {
                if button.name == "btn0" {
                    let tower = SpeedTower(size: ground.size, position: ground.position)
                    tower.delegate = self
                    towers.add(tower)
                    usableGround.remove(tower)
                    addChild(tower)
                    
                } else if button.name == "btn1" {
                    let tower = DamageTower(size: ground.size, position: ground.position)
                    tower.delegate = self
                    towers.add(tower)
                    usableGround.remove(tower)
                    addChild(tower)
                } else if button.name == "btn2" {
                    let tower = RangeTower(size: ground.size, position: ground.position)
                    tower.delegate = self
                    towers.add(tower)
                    usableGround.remove(tower)
                    addChild(tower)
                } else if button.name == "btn3" {
                    let tower = DoubleShotTower(size: ground.size, position: ground.position)
                    tower.delegate = self
                    towers.add(tower)
                    usableGround.remove(tower)
                    addChild(tower)
                }
                self.coins -= 50
                self.hudLayer.setCoins(newCoins: self.coins)
                button.deselect()
            }
        }
    }

    public func setState(newState: GameStateMachine) {
        if state != newState {
            self.state = newState
            self.hudLayer.setState(newState: newState)
            self.spawn.setState(newState: newState)
            
            for tower in towers {
                if let tower = tower as? Tower {
                    tower.setState(newState: newState)
                }
            }
            
            switch newState {
            case .idle:
                self.coins += coinsPerLevel[self.spawn.getCurrentLevel()]
                self.hudLayer.setCoins(newCoins:  self.coins)

            case .playing:
                break
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if state == .idle {
            hudLayer.mouseDown(with: event)
            let point = event.location(in: self)
            
            var shouldAddTower : Bool = true
            
            for tower in towers {
                if let tower = tower as? Tower {
                    if tower.contains(point) {
                        tower.towerMenu.activate()
                        tower.towerMenu.mouseDown(with: event)
                    } else {
                        tower.towerMenu.disable()
                    }
                }
            }
            
            for ground in usableGround {
                if let ground = ground as? Ground {
                    if ground.contains(point) {
                        for tower in towers {
                            if let tower = tower as? Tower {
                                if tower.contains(point) {
                                    shouldAddTower = false
                                    break
                                }
                            }
                        }
                        if shouldAddTower {
                            addTower(in: ground)
                            break
                        }
                    }
                }
            }
        }
    }
    
    //Mark - Spawn Delegate

    public func addEnemy(enemyNode: Enemy) {
        addChild(enemyNode)
        enemyNode.move()
    }
    
    public func endLevel() {
        self.setState(newState: .idle)
    }
    
    //Mark - MapLoader Delegate
    
    public func nodeForMatrix(mapHeight: Int, mapWidth: Int, index: Int, objCode: Int, spriteSize: CGSize) {
        if objCode != 0 {
            let yPosition = Double(spriteSize.height) * Double(Int(index/mapWidth))
            let xPosition = Double(spriteSize.width) * Double(index % mapWidth)
            
            let position =  CGPoint(x: xIniPos - xPosition, y: yIniPos + yPosition)
            
            if objCode == 2 || objCode == 8 {
                let node = Ground(position: position, code: objCode, size: spriteSize)
                addChild(node)
                if objCode == 8 {
                    self.usableGround.add(node)
                }
                
            } else if objCode == 3 {
                self.spawn = Spawn(position: position, code: objCode, size: spriteSize, enemiesLvl: enemiesPerLvl)
                self.spawn.delegate = self
                addChild(self.spawn)
            } else if objCode == 4 {
                self.castle = Castle(position: position, code: objCode, size: spriteSize)
                addChild(self.castle)
            }
        }
    }
    
    //Mark - HudLayer Delegate
    
    public func startRound() {
        setState(newState: .playing)
    }
    
    //Mark - Tower Delegate
    
    func removeTower(tower: Tower) {
        self.towers.remove(tower)
        self.usableGround.add(tower)
        
        self.coins += 50
        self.hudLayer.setCoins(newCoins:  self.coins)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "Castle"  {
            if let castle = contact.bodyA.node as? Castle {
                if let enemy = contact.bodyB.node as? Enemy {
                    castle.loseLife(with: enemy.getDamageValue(), completion: {
                        //EndGame
                    })
                    spawn.removeEnemy(enemy: enemy)
                }
            }
        } else if contact.bodyA.node?.name == "Projectile" {
            if let projectile = contact.bodyA.node as? Projectile {
                if let enemy = contact.bodyB.node as? Enemy {
                    projectile.removeAllActions()
                    enemy.loseLife(with: projectile.damage, completion: {
                        self.removeEnemyFromGame(enemy: enemy)
                    })
                    projectile.removeFromParent()
                }
            }
        } else if contact.bodyA.node?.name == "Enemy" {
            if let enemy = contact.bodyA.node as? Enemy {
                if let projectile = contact.bodyB.node as? Projectile {
                    
                    projectile.removeAllActions()
                    enemy.loseLife(with: projectile.damage, completion: {
                        self.removeEnemyFromGame(enemy: enemy)
                    })
                    projectile.removeFromParent()
                }
                
                if let castle = contact.bodyB.node as? Castle {
                    castle.loseLife(with: enemy.getDamageValue(), completion: {
                        //EndGame
                    })
                    spawn.removeEnemy(enemy: enemy)
                }
            }
        }
    }
    
    func removeEnemyFromGame(enemy: Enemy) {
        self.spawn.removeEnemy(enemy: enemy)
        self.score += enemy.getScoreValue()
        self.hudLayer.setScore(newScore: self.score)
    }
}