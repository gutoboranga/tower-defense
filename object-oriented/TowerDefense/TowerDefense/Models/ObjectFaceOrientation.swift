//
//  ObjectFaceOrientation.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import Foundation

enum ObjectFaceOrientation : Float {
    case right = 270.0
    case left  = 90.0
    case up   = 0.0
    case down = 180.0
    
    init(move : [CGFloat]) {
        let x = move[0]
        let y = move[1]
        
        if (x > CGFloat(0)) {
            self = .right
        } else if (x < CGFloat(0)) {
            self = .left
        } else if (y > CGFloat(0)) {
            self = .up
        } else {
            self = .down
        }
    }
    
    var nextClockwise: ObjectFaceOrientation {
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
    
    func getRotationAngle(newOrientation : ObjectFaceOrientation) -> CGFloat {
        if newOrientation == self.nextClockwise {
            return -(CGFloat.pi / 2)
        }
        return CGFloat.pi/2
    }
}

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * CGFloat.pi / 180
    }
}
