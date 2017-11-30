//
//  Enemy.swift
//  TowerDefense
//
//  Created by Augusto Boranga on 16/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    private let directions : [[CGFloat]]
    private let eSpeed  : Double = 0.1
    private var lifeBar : LifeBar

    private var orientation = Orientation(direction: .right)
    
    init(name : String, position: CGPoint, life: Double, directions: [[CGFloat]]) {
        
        let size = CGSize(width: 32, height: 32)
        
        self.lifeBar = LifeBar(size: size, lifeNumber: life)
        self.directions = directions
        
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .clear, size: size)
        
        self.name = "Enemy"
        
        self.position = position

        self.zPosition = 2
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        self.addChild(lifeBar)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size, center: CGPoint(x: 0, y: 0))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.categoryBitMask = ColliderType.Enemy
        self.physicsBody?.contactTestBitMask = ColliderType.Castle
    }
    
    public func loseLife(with damage:Double, completion: () -> ()) {
        lifeBar.loseLife(with: damage) {
            completion()
        }
    }
    
    public func move() {
        let firstMove = directions.first!
        let time : Double = eSpeed * 2.0 * Double(firstMove[0] + firstMove[1])
        let action = SKAction.move(by: CGVector(dx: 32 * firstMove[0], dy:  32 * firstMove[1]), duration: abs(time))
        run(action) {
            var dir = self.directions
            dir.removeFirst()
            self.move(dir)
        }
    }
    
    private func move(_ newDir : [[CGFloat]]) {
        if let firstMove = newDir.first {
            let rotateAction = self.orientation.getAction(move: firstMove)
            
            self.run(rotateAction, completion: {
                self.orientation.updateDirection(move: firstMove)
                
                let time : Double = self.eSpeed * 2.0 * Double(firstMove[0] + firstMove[1])
                let action = SKAction.move(by: CGVector(dx: 32 * firstMove[0], dy:  32 * firstMove[1]), duration: abs(time))
                self.run(action) {
                    var dir = newDir
                    dir.removeFirst()
                    self.move(dir)
                }
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getName() -> String {
        preconditionFailure("This method must be overridden")
    }
    
    public func getDamageValue() -> Double {
        preconditionFailure("This method must be overridden")
    }
    
    public func getScoreValue() -> Int {
        preconditionFailure("This method must be overridden")
    }
    
}


class FrogEnemy : Enemy {
    
    init(position: CGPoint, life: Double, directions: [[CGFloat]]) {
        super.init(name: self.getName(), position: position, life: life, directions: directions)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getName() -> String {
        return "frog"
    }
    
    override func getDamageValue() -> Double {
        return 0.5
    }
    override func getScoreValue() -> Int {
        return 100
    }
}


class SpiderEnemy : Enemy {
    
    init(position: CGPoint, life: Double = 12, directions: [[CGFloat]]) {
        super.init(name: self.getName(), position: position, life: life, directions: directions)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getName() -> String {
        return "spider"
    }
    
    override func getDamageValue() -> Double {
        return 1
    }
    
    override func getScoreValue() -> Int {
        return 150
    }
    
}

class AstronautEnemy : Enemy {
    
    var animationFrames = [SKTexture]()
    
    init(position: CGPoint, life: Double = 18, directions: [[CGFloat]]) {
        super.init(name: self.getName() + String(0), position: position, life: life,  directions: directions)
        
        // cria os frames pra animar
        self.animationFrames.append(SKTexture(imageNamed: self.getName() + String(0)))
        self.animationFrames.append(SKTexture(imageNamed: self.getName() + String(1)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getName() -> String {
        return "astronaut"
    }
    
    override func getDamageValue() -> Double {
        return 0.7
    }
    
    override func move() {
        let walkAction = SKAction.animate(
            with: self.animationFrames,
            timePerFrame: 0.1,
            resize: false,
            restore: true)
        
        self.run(SKAction.repeatForever(walkAction), withKey: "walkingAstronaut")
        
        super.move()
    }
    
    override func getScoreValue() -> Int {
        return 70
    }
    
}

class RoverEnemy : Enemy {
    
    init(position: CGPoint, life: Double = 20, directions: [[CGFloat]]) {
        super.init(name: self.getName(), position: position, life: life, directions: directions)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getName() -> String {
        return "rover"
    }
    
    override func getDamageValue() -> Double {
        return 0.09
    }
    
    override func getScoreValue() -> Int {
        return 50
    }
    
}
