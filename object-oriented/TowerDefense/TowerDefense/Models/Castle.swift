//
//  Castle.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit


class Castle: SKSpriteNode {

    var lifeBar : LifeBar
    
    init(position: CGPoint, code: Int, size: CGSize) {
        
        self.lifeBar = LifeBar(size: CGSize(width: 32, height: 32), lifeNumber: 100)
        
        let txt = SKTexture(imageNamed: code.description)
        super.init(texture: txt, color: .clear, size: size)
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.name = "Castle"
        self.position = position
        self.zPosition = 3
        
        self.addChild(lifeBar)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
