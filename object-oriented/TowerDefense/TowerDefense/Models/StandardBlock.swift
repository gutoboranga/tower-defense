//
//  StandardBlock.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 29/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

class StandardBlock: SKSpriteNode {
    
    
    public var orientation : ObjectFaceOrientation
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        self.orientation = .up
        super.init(texture: texture, color: color, size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func rotateLeft() {
        switch self.orientation {
        case .up:
            self.setOrientation(to: .left)
        case .right:
            self.setOrientation(to: .up)
        case .down:
            self.setOrientation(to: .right)
        case .left:
            self.setOrientation(to: .down)
        }
    }
    
    public func rotateRight() {
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
    
    private func setOrientation(to newOrientation:ObjectFaceOrientation) {
        if self.orientation != newOrientation {
            self.zRotation = CGFloat(newOrientation.rawValue).degreesToRadians()
            self.orientation = newOrientation
        }
    }
    
}
