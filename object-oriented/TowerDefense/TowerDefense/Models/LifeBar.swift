//
//  LifeBar.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

class LifeBar: StandardBlock {
    
    private var life      : Double
    private var atualLife : Double
    private var lifeBarSize : CGFloat
    private var lifeBar   : SKSpriteNode
    
    init(size: CGSize, lifeNumber: Double) {
        
        self.life = lifeNumber
        self.atualLife = lifeNumber
        
        let width = size.width*0.7
        self.lifeBarSize = width-2.0
        
        self.lifeBar = SKSpriteNode(color: .green, size: CGSize(width:  lifeBarSize, height: 2.0))
        self.lifeBar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        self.lifeBar.position    = CGPoint(x: -width/2+1, y: 0.0)
        self.lifeBar.zPosition   = 6

        let newSize = CGSize(width: width, height: 4)
        super.init(texture: nil, color: .black, size: newSize)

        self.position = CGPoint(x: 0.0, y: -width/2 + 1)
        self.zPosition   = 5

        self.addChild(lifeBar)
    }
    
    func loseLife(with damage: Double, completion: () -> Void) {
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
        let action = SKAction.resize(toWidth: CGFloat(self.atualLife * Double(lifeBarSize) / self.life) , duration: 0.2)
        lifeBar.run(action)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
