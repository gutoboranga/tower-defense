//
//  Enemy.swift
//  TowerDefense
//
//  Created by Augusto Boranga on 16/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    let directions : [[CGFloat]] = [[2.0,0.0],
                                    [0.0,-12.0],
                                    [3.0,0.0],
                                    [0.0,13.0],
                                    [7.0,0.0],
                                    [0.0,-4.0],
                                    [-5.0,0.0],
                                    [0.0,-9.0],
                                    [3.0,0.0],
                                    [0.0,5.0],
                                    [4.0,0.0],
                                    [0.0,5.0],
                                    [3.0,0.0],
                                    [0.0,-8.0],
                                    [2.0,0.0]]
    
    let eSpeed  : Double = 0.2
    let eDamage : Double = 0.1
    
    var lifeBar : LifeBar
    
    
    init(name : String, position: CGPoint, life: Double) {
        self.lifeBar = LifeBar(size: CGSize(width: 32, height: 32), lifeNumber: life)
        
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .clear, size: CGSize(width: 32, height: 32))
        
        self.position = position
        self.zPosition = 4
        self.anchorPoint = CGPoint(x: 0, y: 0)

        self.addChild(lifeBar)
        
    }
    
    func move() {
        let firstMove = directions.first!
        let time : Double = eSpeed * 2.0 * Double(firstMove[0] + firstMove[1])
        let action  = SKAction.moveBy(x: 32.0 * firstMove[0] , y: 32 * firstMove[1], duration: abs(time))
        run(action) {
            var dir = self.directions
            dir.removeFirst()
            self.move(dir)
        }
    }
    
    func move(_ newDir : [[CGFloat]]) {
        if let firstMove = newDir.first {
            let time : Double = eSpeed * 2.0 * Double(firstMove[0] + firstMove[1])
            let action  = SKAction.moveBy(x: 32.0 * firstMove[0] , y: 32 * firstMove[1], duration: abs(time))
            run(action) {
                var dir = newDir
                dir.removeFirst()
                self.move(dir)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
