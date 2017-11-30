//
//  Ground.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 27/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

class Ground: StandardBlock {

    init(position: CGPoint, code: Int, size: CGSize) {
        let txt = SKTexture(imageNamed: code.description)
        super.init(texture: txt, color: .clear, size: size)

        self.name = getNodeName(with: code)
        self.position = position
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getNodeName(with code: Int) -> String{
        switch code {
        case 8:
            return "ground"
        case 2:
            return "road"
        default:
            return "ground"
        }
    }
    
}
