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

class GameScene: SKScene, MapDeglegate, HudLayerDelegate, SpawnDelegate, SKPhysicsContactDelegate{
    
    private let xIniPos = 716.0
    private let yIniPos = 390.0
    
    private var mapLoader : MapLoader!
    private var spawn     : Spawn!
    private var castle    : Castle!
    private var hudLayer  : HudLayer!
    private var state     : GameStateMachine!
    
    private var usableGround : NSMutableArray = NSMutableArray()
    private var towers       : NSMutableArray = NSMutableArray()
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        self.scene?.position = CGPoint(x: 0, y: 0)
        self.physicsWorld.contactDelegate = self
        
        self.state = .idle
        
        self.mapLoader = MapLoader()
        self.mapLoader.delegate = self
        self.mapLoader.loadMap()
        
        self.hudLayer = HudLayer(texture: nil, color: .clear, size: size)
        self.hudLayer.delegate = self
        addChild(hudLayer)
  
    }
    
    private func addTower(in ground: Ground) {
        if let button = hudLayer?.selectedButton {
            
            var color : NSColor = .red
            if button.name == "btn1" {
                color = .cyan
            } else if button.name == "btn2" {
                color = .yellow
            }
            
            let tower = Tower(texture: nil, size: ground.size, damage: 8, range: 700, speed: 1)
            tower.position = ground.position
            tower.color = color
            towers.add(tower)
            usableGround.remove(tower)
            addChild(tower)
            button.deselect()
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
                break
            case .playing:
                break
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        hudLayer.mouseDown(with: event)
        
        let point = event.location(in: self)
        
        var shouldAddTower : Bool = true
        
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
                spawn = Spawn(position: position, code: objCode, size: spriteSize)
                spawn.delegate = self
                addChild(spawn)
            } else if objCode == 4 {
                castle = Castle(position: position, code: objCode, size: spriteSize)
                addChild(castle)
            }
        }
    }
    
    //Mark - HudLayer Delegate
    
    public func startRound() {
        setState(newState: .playing)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Castle"  {
            if let castle = contact.bodyA.node as? Castle {
                if let enemy = contact.bodyB.node as? Enemy {
                    castle.loseLife(with: enemy.eDamage)
                    spawn.removeEnemy(enemy: enemy)
                }
            }
        } else if contact.bodyA.node?.name == "Projectile" {
            if let projectile = contact.bodyA.node as? Projectile {
                if let enemy = contact.bodyB.node as? Enemy {
                    projectile.removeAllActions()
                    enemy.loseLife(with: projectile.damage, completion: {
                        self.spawn.removeEnemy(enemy: enemy)
                    })
                    projectile.removeFromParent()
                }
            }
        }
    }
}


