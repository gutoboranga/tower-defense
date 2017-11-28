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
}

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * CGFloat.pi / 180
    }
}
