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
    
}

class Tower: SKSpriteNode, TowerMenuDelegate {
    
    public var towerMenu : TowerMenu
    
    private var orientation : ObjectFaceOrientation
    private var state       : GameStateMachine
    
    private var selected : Bool
    
    public var damage : Double
    public var range  : Double
    public var tSpeed : Double
    public var shotRate : Double
    public var delegate : TowerDelegate!
    
    init(texture: SKTexture?, size: CGSize, position: CGPoint, orientation : ObjectFaceOrientation = .up, damage: Double, range: Double, speed: Double, shotRate: Double) {
        self.orientation = orientation
        self.state       = .idle
        self.damage      = damage
        self.range       = range
        self.tSpeed      = speed
        self.shotRate    = shotRate
        self.selected    = false
        self.towerMenu = TowerMenu(size: size)
        
        
        super.init(texture: texture, color: .blue, size: size)
        
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
    
    private func enterInCombat() {
        let action = SKAction.move(by: CGVector(dx: 0.0, dy: range), duration: tSpeed)
        fire(action: action)
    }
    
    private func fire(action: SKAction) {
        
        let node = Projectile(damage: damage, size: CGSize(width: 4, height: 4))
        node.position = CGPoint(x: 0, y: 0)
        
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
    
    func rotateRight() {
        switch self.orientation {
        case .up:
            self.setOrientation(to: .right)
        case .right:
            self.setOrientation(to: .down)
        case .down:
            self.setOrientation(to: .left)
        case .left:
            self.setOrientation(to: .up)
        }
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
    
    public func setOrientation(to newOrientation:ObjectFaceOrientation) {
        if self.orientation != newOrientation {
            self.zRotation = CGFloat(newOrientation.rawValue).degreesToRadians()
            self.orientation = newOrientation
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
    
    // Mark - Tower Menu Delegate
    
    func removeTower() {
        delegate.removeTower(tower: self)
        removeFromParent()
    }
    
    func rotate() {
        rotateRight()
    }
    
    func upgrade() {
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
