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
            let s = ground.size
            let p = ground.position
            
            switch button.name! {
            case "speed":
                tower = SpeedTower(size: s, position: p)
            case "damage":
                tower = DamageTower(size: s, position: p)
            case "range":
                tower = RangeTower(size: s, position: p)
            default:
                tower = DoubleShotTower(size: s, position: p)
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
            
            towers.forEach({ (tower) in
                if let t = tower as? Tower {
                    t.setState(newState: newState)
                }
            })
            
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
            
            // confere se já há um torre no ponto clicado pelo jogador
            let foundTower = towers.reduce(false, { (hasFoundTowerYet, tower) -> Bool in
                if let t = tower as? Tower {
                    if t.contains(point) {
                        t.mouseDown(with: event)
                        return hasFoundTowerYet || true
                    }
                }
                return hasFoundTowerYet || false
            })
            
            // se não havia torre no lugar clicado
            if (!foundTower) {
                // tira menu de todas torres (pois clicou "fora")
                towers.forEach({ tower in
                    (tower as! Tower).towerMenu.disable()
                })
                
                // confere se o clique foi em um ponto usável do mapa:
                // se foi e tiver selecionado uma torre antes, adiciona ela naquele ponto do mapa
                usableGround.forEach({ ground in
                    if let g = ground as? Ground {
                        if g.contains(point) && shouldAddTower {
                            addTower(in: g)
                        }
                    }
                })
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
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        switch nodeA?.name! {
        case "Castle"?:
            if nodeB?.name! == "Enemy" {
                handleEnemyAndCastleContact(enemyNode: nodeB, castleNode: nodeA)
            }
            
        case "Enemy"?:
            switch nodeB?.name! {
            case "Castle"?:
                handleEnemyAndCastleContact(enemyNode: nodeA, castleNode: nodeB)
                
            case "Projectile"?:
                handleProjectileAndEnemyContact(projectileNode: nodeB, enemyNode: nodeA)
                
            default:
                break
            }
        
        case "Projectile"?:
            if nodeB?.name! == "Enemy" {
                handleProjectileAndEnemyContact(projectileNode: nodeA, enemyNode: nodeB)
            }
        
        default:
            break
        }
        
        return 0
    }
    
    func handleEnemyAndCastleContact(enemyNode: SKNode?, castleNode: SKNode?) {
        if let castle = castleNode as? Castle {
            if let enemy = enemyNode as? Enemy {
                castle.loseLife(with: enemy.getDamageValue(), completion: {
                    self.removeFromParent()
                    self.gameDelegate?.endOfGame(won: false, score: self.score)
                })
                spawn.removeEnemy(enemy: enemy)
            }
        }
    }
    
    func handleProjectileAndEnemyContact(projectileNode: SKNode?, enemyNode: SKNode?) {
        if let enemy = enemyNode as? Enemy {
            if let projectile = projectileNode as? Projectile {
                projectile.removeAllActions()
                enemy.loseLife(with: projectile.damage, completion: {
                    self.removeEnemyFromGame(enemy: enemy)
                })
                projectile.removeFromParent()
            }
        }
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
