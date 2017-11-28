//
//  LifeBar.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

class LifeBar: SKSpriteNode {
    
    var life      : Double
    var atualLife : Double
    
    var lifeBarSize : Double
    
    var lifeBar   : SKSpriteNode
    
    init(size: CGSize, lifeNumber: Double) {
        
        self.life = lifeNumber
        self.atualLife = lifeNumber
        
        self.lifeBarSize = Double(size.width * 0.25)
        
        self.lifeBar = SKSpriteNode(color: .green, size: CGSize(width:  lifeBarSize, height: 2))
        self.lifeBar.anchorPoint = CGPoint(x: 0, y: 0)
        self.lifeBar.position    = CGPoint(x: 1, y: 1)
        self.lifeBar.zPosition   = 6
        
        let newSize = CGSize(width: size.width * 0.32, height: 4)
        super.init(texture: nil, color: .black, size: newSize)
        
        self.position = CGPoint(x: size.width/2 - size.width * 0.32 / 2, y: 0)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition   = 5

        self.addChild(lifeBar)
    }
    
    func getDamaged(damage: Double, completion: () -> Void) {
        self.atualLife -= damage
        
        if self.atualLife <= 0 {
            completion()
        }
        
        let lifePorcentage = atualLife*100 / life
        
        if lifePorcentage <= 60 && lifePorcentage > 25 {
            self.lifeBar.color = .yellow
        }else if lifePorcentage <= 25 {
            self.lifeBar.color = .red
        }
        let action = SKAction.resize(toWidth: CGFloat(self.atualLife * lifeBarSize / self.life) , duration: 0.2)
        lifeBar.run(action)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
