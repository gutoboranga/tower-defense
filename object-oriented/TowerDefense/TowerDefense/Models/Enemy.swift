//
//  Enemy.swift
//  TowerDefense
//
//  Created by Augusto Boranga on 16/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    private let directions : [[CGFloat]] = [[2.0,0.0],
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
    
    private let eSpeed  : Double = 0.05
    private var lifeBar : LifeBar
    
    public let eDamage : Double = 0.02
    
    init(name : String, position: CGPoint, life: Double) {
        
        let size = CGSize(width: 32, height: 32)
        
        self.lifeBar = LifeBar(size: size, lifeNumber: life)
        
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .clear, size: size)
        
        self.position = position
        self.zPosition = 4
        self.anchorPoint = CGPoint(x: 0, y: 0)

        self.addChild(lifeBar)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.collisionBitMask = ColliderType.Castle
        self.physicsBody?.categoryBitMask = ColliderType.Enemy
        self.physicsBody?.contactTestBitMask = ColliderType.Castle
        
    }
    
    func move() {
        let firstMove = directions.first!
        let time : Double = eSpeed * 2.0 * Double(firstMove[0] + firstMove[1])
        let action = SKAction.move(by: CGVector(dx: 32 * firstMove[0], dy:  32 * firstMove[1]), duration: abs(time))
        run(action) {
            var dir = self.directions
            dir.removeFirst()
            self.move(dir)
        }
    }
    
    func move(_ newDir : [[CGFloat]]) {
        if let firstMove = newDir.first {
            let time : Double = eSpeed * 2.0 * Double(firstMove[0] + firstMove[1])
            let action = SKAction.move(by: CGVector(dx: 32 * firstMove[0], dy:  32 * firstMove[1]), duration: abs(time))
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