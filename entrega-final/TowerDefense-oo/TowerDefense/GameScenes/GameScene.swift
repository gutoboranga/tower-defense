//
//  GameScene.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 27/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

protocol GameDelegate {
    func endOfGame(won: Bool, score: Int)
}

import SpriteKit
import GameplayKit

enum GameStateMachine {
    case idle
    case playing
}

class GameScene: SKScene, MapDelegate, HudLayerDelegate, SpawnDelegate, TowerDelegate, SKPhysicsContactDelegate{
    
    var gameDelegate: GameDelegate?
    
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
    }
    
    private func addTower(in ground: Ground) {
        
        if let button = hudLayer?.selectedButton {
            var tower : Tower!
            
            if button.name == "speed" {
                tower = SpeedTower(size: ground.size, position: ground.position)
            } else if button.name == "damage" {
                tower = DamageTower(size: ground.size, position: ground.position)
            } else if button.name == "range" {
                tower = RangeTower(size: ground.size, position: ground.position)
            } else if button.name == "doubleShot" {
                tower = DoubleShotTower(size: ground.size, position: ground.position)
            }
            
            tower.delegate = self
            
             if coins >= tower.getPrice() {
                self.towers.add(tower)
                self.usableGround.remove(tower)
                self.addChild(tower)
                self.setCoins(addValue: -tower.getPrice())
                
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
                
                if self.spawn.getCurrentLevel() == coinsPerLevel.count {
                    self.removeFromParent()
                    self.gameDelegate?.endOfGame(won: true, score: self.score)
                } else {
                    self.setCoins(addValue: coinsPerLevel[self.spawn.getCurrentLevel()])
                }
                
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
    
    private func setScore(addValue value:Int) {
        self.score += value
        self.hudLayer.setScore(newScore: self.score)
    }
    
    private func setCoins(addValue value:Int) {
        self.coins += value
        self.hudLayer.setCoins(newCoins: self.coins)
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
    
    func upgradeTower(tower: Tower) {
        if tower.getLevel() < 3 {
            if coins >= tower.getUpgratePrice() {
                setCoins(addValue: -tower.getUpgratePrice())
                tower.upgrateTower()
            }
        }
    }
    
    func removeTower(tower: Tower) {
        self.towers.remove(tower)
        self.usableGround.add(tower)
        self.setCoins(addValue: tower.getPrice())
    }
    
    func sameType<T,E>(one : T, two: E) -> Bool {
        if type(of: one) == type(of: two) {
            return true
        }
        return false
    }
    
    func handleContact(_ contact: SKPhysicsContact) -> Int {
        if !sameType(one: contact.bodyA.node, two: contact.bodyB.node) {
            print("physics error")
            return -1
        }
        
        if contact.bodyA.node?.name == "Castle"  {
            if let castle = contact.bodyA.node as? Castle {
                if let enemy = contact.bodyB.node as? Enemy {
                    castle.loseLife(with: enemy.getDamageValue(), completion: {
                        self.removeFromParent()
                        self.gameDelegate?.endOfGame(won: false, score: self.score)
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
                        self.removeFromParent()
                        self.gameDelegate?.endOfGame(won: false, score: self.score)
                    })
                    spawn.removeEnemy(enemy: enemy)
                }
            }
        }
        
        return 0
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let _ = handleContact(contact)
    }
    
//    func gameOver() {
//        //IMPLEMENTAR GAME OVER
//        print("GAME OVER")
//
//        self.gameDelegate?.endOfGame()
//    }
//
//    func winGame() {
//        //IMPLEMENTAR
//        print("WIN")
//    }
    
    func removeEnemyFromGame(enemy: Enemy) {
        self.spawn.removeEnemy(enemy: enemy)
        self.setScore(addValue: enemy.getScoreValue())
    }
}
