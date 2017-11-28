//
//  Tower.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

class Tower: SKSpriteNode {
    
    private var orientation : ObjectFaceOrientation
    private var state       : GameStateMachine
    
    private var selected : Bool
    
    public var damage : Double
    public var range  : CGFloat
    public var tSpeed : Double
    
    init(texture: SKTexture?, size: CGSize, orientation : ObjectFaceOrientation = .up, damage: Double, range: CGFloat, speed: Double) {
        self.orientation = orientation
        self.state       = .idle
        self.damage      = damage
        self.range       = range
        self.tSpeed      = speed
        self.selected    = false
        super.init(texture: texture, color: .blue, size: size)
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = 5
        self.zRotation = CGFloat(self.orientation.rawValue).degreesToRadians()
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
                break
            case .playing:
                break
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
