//
//  MapLoader.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 27/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import Foundation
import SpriteKit

protocol MapDeglegate {
    func nodeForMatrix(node: SKSpriteNode)
    func spawnner(_ spawn: Spawn)
}

class MapLoader {
    
    var delegate : MapDeglegate?
    
    let xIniPos = 716.0
    let yIniPos = 467.0
    
    let spriteHeight  = 32.0
    let spriteWidth = 32.0
    
    let mapName =  "Tower-Defense"
    
    func loadMap() {
        if let gamePhase = loadGame(named: mapName) {
            
            let width  = gamePhase["width"] as? Int ?? 15
            
            if let layers = gamePhase["layers"] as? [[String:Any?]]{
                for layer in layers {
                    if let data = layer["data"] as? [Int] {
                        for (index, obj) in data.reversed().enumerated() {
                            if obj != 0 {
                                let yPosition = spriteHeight * Double(Int(index/width))
                                let xPosition = spriteWidth * Double(index % width)
                                
                                let size = CGSize(width: spriteWidth, height: spriteHeight)
                                let position =  CGPoint(x: xIniPos - xPosition, y: yIniPos + yPosition)
                                
                                if obj == 2 || obj == 8 {
                                    let node = Ground(position: position, code: obj, size: size)
                                    delegate?.nodeForMatrix(node: node)
                                } else if obj == 3 {
                                    let node = Spawn(position: position, code: obj, size: size)
                                    delegate?.nodeForMatrix(node: node)
                                    delegate?.spawnner(node)
                                } else if obj == 4 {
                                    let node = Castle(position: position, code: obj, size: size)
                                    delegate?.nodeForMatrix(node: node)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadGame(named levelName:String) -> [String:Any?]?{
        if let path : String = Bundle.main.path(forResource: levelName, ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do{
                    let data = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any?]
                    return data
                }catch{
                    return nil
                }
            }
        }
        return nil
    }
    
}
