//
//  Castle.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit


class Castle: SKSpriteNode {

    private var lifeBar : LifeBar
    
    init(position: CGPoint, code: Int, size: CGSize) {
        
        self.lifeBar = LifeBar(size: size, lifeNumber: 10)
        
        let txt = SKTexture(imageNamed: code.description)
        super.init(texture: txt, color: .clear, size: size)
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.name = "Castle"
        self.position = position
        self.zPosition = 3
        
        self.addChild(lifeBar)
        
        //Castle Physiscs
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width - 0.1, height: size.height - 0.1))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.Castle
        
    }
    
    func loseLife(with damage:Double) {
        lifeBar.loseLife(with: damage) {
            removeFromParent()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
