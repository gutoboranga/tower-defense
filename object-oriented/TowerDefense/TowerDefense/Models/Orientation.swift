//
//  Direction.swift
//  TowerDefense
//
//  Created by Augusto Boranga on 29/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit
import Foundation

enum Direction {
    case up, right, down, left
    
    var nextClockwise: Direction {
        switch self {
        case .up:
            return .right
        case .right:
            return .down
        case .down:
            return .left
        case .left:
            return .up
        }
    }
}

class Orientation {
    var currentDirection : Direction
    
    init(direction : Direction) {
        self.currentDirection = direction
    }
    
    private func setDirection(newDirection : Direction) {
        self.currentDirection = newDirection;
    }
    
    private func getRotationAngle(newDirection : Direction) -> CGFloat {
        // se vai virar em sentido horário
        if newDirection == self.currentDirection.nextClockwise {
            return -(CGFloat.pi / 2)
        }

        return CGFloat.pi/2
    }
    
    private func getDirectionFromMove(move : [CGFloat]) -> Direction{
        let x = move[0]
        let y = move[1]
        
        if (x > CGFloat(0)) {
            return Direction.right
        } else if (x < CGFloat(0)) {
            return Direction.left
        } else if (y > CGFloat(0)) {
            return Direction.up
        } else {
            return Direction.down
        }
    }
    
    func updateDirection(move : [CGFloat]) {
        self.currentDirection = getDirectionFromMove(move: move)
    }
    
    func getAction(move : [CGFloat]) -> SKAction {
        
        let newDirection = getDirectionFromMove(move: move)
        let angle : CGFloat = getRotationAngle(newDirection: newDirection)
        
        return SKAction.rotate(byAngle: angle, duration: 0.1)
    }
}
