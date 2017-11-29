//
//  Projectile.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

class Projectile: SKSpriteNode {

    public var damage : Double
    
    init(damage: Double, size: CGSize) {
        
        self.damage = damage
        
        super.init(texture: nil, color: .purple, size: size)
        
        self.zPosition = 4
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.name = "Projectile"
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width + 1, height: size.height + 1))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = ColliderType.Castle
        self.physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
