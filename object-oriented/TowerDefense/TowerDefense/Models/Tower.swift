//
//  Tower.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

protocol TowerDelegate {
    func removeTower(tower : Tower)
    func upgradeTower(tower: Tower)
}

class Tower: StandardBlock, TowerMenuDelegate {
    
    public let upgratePrices = [50, 100, 150]
    
    public var towerMenu : TowerMenu
    private var state    : GameStateMachine
    
    private var selected : Bool
    private var level : Int
    
    public var damage : Double
    public var range  : Double
    public var tSpeed : Double
    public var shotRate : Double
    public var delegate : TowerDelegate!
    
    init(texture: SKTexture?, size: CGSize, position: CGPoint, orientation : ObjectFaceOrientation = .up, damage: Double, range: Double, speed: Double, shotRate: Double) {

        self.level     = 0
        self.state     = .idle
        self.damage    = damage
        self.range     = range
        self.tSpeed    = speed
        self.shotRate  = shotRate
        self.selected  = false
        self.towerMenu = TowerMenu(size: size)
        
        super.init(texture: texture, color: .blue, size: size)
        
        self.orientation = orientation
        self.position = position
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 5
        self.zRotation = CGFloat(self.orientation.rawValue).degreesToRadians()
        
        self.towerMenu.delegate = self
        self.addChild(towerMenu)
    }
    
    private func stopCombat() {
        removeAllActions()
    }
    
    public func getPrice() -> Int {
        return 50
    }
    
    public func enterInCombat() {
        fire(action: getProjectileAction())
    }
    
    public func fire(action: SKAction) {
        let node = getProjectile()
        let wait = SKAction.wait(forDuration: tSpeed/shotRate)
        run(wait) {
            self.addChild(node)
            node.run(action, completion: {
                node.removeFromParent()
            })
            self.fire(action: action)
        }
    }
    
    public func remove() {
        delegate.removeTower(tower: self)
        removeFromParent()
    }
    
    public func setState(newState: GameStateMachine) {
        if state != newState {
            self.state = newState
            switch newState {
            case .idle:
                self.stopCombat()
            case .playing:
                self.enterInCombat()
                self.towerMenu.disable()
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        
        let point = event.location(in: self)
        if towerMenu.isActive() {
            if towerMenu.contains(point){
                
            } else {
                towerMenu.disable()
            }
        } else {
            if self.contains(point) {
                towerMenu.activate()
            }
        }
    }
    
    public func getProjectile() -> Projectile{
        return Projectile(damage: damage, size: CGSize(width: 5, height: 7))
    }
    
    public func getProjectileAction() -> SKAction {
        return SKAction.move(by: CGVector(dx: 0.0, dy: range), duration: tSpeed)
    }
    
    public func getUpgratePrice() -> Int{
        return upgratePrices[level]
    }
    
    public func upgrateTower() {
        if level < 3 {
            self.level += 1
            self.towerMenu.upgradeLevel()
            self.upgrateAtributes()
        }
    }
    
    public func upgrateAtributes() {
        
    }
    
    public func getLevel() -> Int{
        return self.level
    }
    
    // Mark - Tower Menu Delegate
    
    func removeTower() {
        delegate.removeTower(tower: self)
        removeFromParent()
    }
    
    func rotate() {
        rotateRight()
    }
    
    func upgrade() {
        delegate.upgradeTower(tower: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SpeedTower : Tower {
    
    init( size: CGSize, position: CGPoint) {
        super.init(texture: nil, size: size, position: position, damage: 0.3, range: 300, speed: 0.7, shotRate: 6)
        self.color = .red
    }
    
    override func getProjectile() -> Projectile{
        return Projectile(damage: damage, size: CGSize(width: 4, height: 4))
    }
    
    override func upgrateAtributes() {
        self.tSpeed *= 1.0 - (0.2 * Double(getLevel()))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DamageTower : Tower {
    
    init( size: CGSize, position: CGPoint) {
        super.init(texture: nil, size: size, position: position, damage: 5, range: 150, speed: 2, shotRate: 2)
        self.color = .blue
    }
    
    override func getProjectile() -> Projectile{
        return Projectile(damage: damage, size: CGSize(width: 10, height: 10))
    }
    
    override func upgrateAtributes() {
        self.damage *= 1.0 + (0.2 * Double(getLevel()))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RangeTower : Tower {
    
    init( size: CGSize, position: CGPoint) {
        super.init(texture: nil, size: size, position: position, damage: 1.5, range: 600, speed: 1.3, shotRate: 4)
        self.color = .purple
    }
    
    override func getProjectile() -> Projectile{
        return Projectile(damage: damage, size: CGSize(width: 10, height: 10))
    }
    
    override func upgrateAtributes() {
        self.range *= 1.0 + (0.2 * Double(getLevel()))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DoubleShotTower : Tower {
    
    init( size: CGSize, position: CGPoint) {
        super.init(texture: nil, size: size, position: position, damage: 1, range: 250, speed: 1, shotRate: 2)
        self.color = .orange
    }
    
    override func getProjectile() -> Projectile{
        return Projectile(damage: damage, size: CGSize(width: 7, height: 7))
    }
    
    override func enterInCombat() {
        switch getLevel() {
        case 3:
            fire(action: SKAction.move(by: CGVector(dx: -range, dy: 0.0), duration: tSpeed))
            fallthrough
        case 2:
            fire(action: SKAction.move(by: CGVector(dx: range, dy: 0.0), duration: tSpeed))
            fallthrough
        case 1:
            fire(action: SKAction.move(by: CGVector(dx: 0.0, dy: -range), duration: tSpeed))
            fallthrough
        case 0:
            fire(action: getProjectileAction())
        default:
            break
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


