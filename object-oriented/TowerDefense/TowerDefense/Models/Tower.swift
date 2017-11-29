//
//  Tower.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

protocol TowerDelegate {
    func addProjectileToScene(projectile : Projectile)
}

class Tower: SKSpriteNode {
    
    private var orientation : ObjectFaceOrientation
    private var state       : GameStateMachine
    
    private var selected : Bool
    
    public var damage : Double
    public var range  : Double
    public var tSpeed : Double
    
    init(texture: SKTexture?, size: CGSize, orientation : ObjectFaceOrientation = .up, damage: Double, range: Double, speed: Double) {
        self.orientation = orientation
        self.state       = .idle
        self.damage      = damage
        self.range       = range
        self.tSpeed      = speed
        self.selected    = false
        super.init(texture: texture, color: .blue, size: size)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 5
        self.zRotation = CGFloat(self.orientation.rawValue).degreesToRadians()
    }
    
    private func stopCombat() {
        removeAllChildren()
        removeAllActions()
    }
    
    private func enterInCombat() {
        
        switch orientation {
        case .up:
            let action = SKAction.move(by: CGVector(dx: 0.0, dy: range), duration: tSpeed)
            fire(action: action)
            
        default:
            let action = SKAction.move(by: CGVector(dx: 0.0, dy: range), duration: tSpeed)
            fire(action: action)
        }
    }
    
    private func fire(action: SKAction) {
        
        let node = Projectile(damage: damage, size: CGSize(width: 4, height: 4))
        node.position = CGPoint(x: 0, y: 0)
        
        let wait = SKAction.wait(forDuration: tSpeed/2)
        run(wait) {
            self.addChild(node)
            node.run(action, completion: {
                node.removeFromParent()
            })
            self.fire(action: action)
        }
    }
    
    public func remove() {
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
            }
        }
    }
    
    public func setOrientation(to newOrientation:ObjectFaceOrientation) {
        if self.orientation != newOrientation {
            self.zRotation = CGFloat(newOrientation.rawValue).degreesToRadians()
            self.orientation = newOrientation
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
