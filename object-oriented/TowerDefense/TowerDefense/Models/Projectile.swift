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
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size, center: CGPoint(x: 0, y: 0))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.categoryBitMask = ColliderType.Castle
        self.physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
