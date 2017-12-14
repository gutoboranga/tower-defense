//
//  Castle.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit


class Castle: StandardBlock {

    private var lifeBar : LifeBar
    
    init(position: CGPoint, code: Int, size: CGSize) {
        
        self.lifeBar = LifeBar(size: size, lifeNumber: 10)
        
        let txt = SKTexture(imageNamed: code.description)
        super.init(texture: txt, color: .clear, size: size)

        self.name = "Castle"
        self.position = position
        self.zPosition = 3
        
        self.addChild(lifeBar)
        
        //Castle Physiscs
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width - 1, height: size.height - 1), center: CGPoint(x: 0, y: 0))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.Obstacle
        
    }
    
    func loseLife(with damage:Double, completion: () ->()) {
        lifeBar.loseLife(with: damage) {
            completion()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
