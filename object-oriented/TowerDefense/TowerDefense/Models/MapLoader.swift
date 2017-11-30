//
//  MapLoader.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 27/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import Foundation
import SpriteKit

protocol MapDelegate {
    func nodeForMatrix(mapHeight: Int, mapWidth: Int, index: Int, objCode: Int, spriteSize: CGSize)
}

class MapLoader {
    
    var delegate : MapDelegate?
    
    let spriteHeight  = 32.0
    let spriteWidth = 32.0
    
    let mapName =  "Tower-Defense"
    
    func loadMap() {
        if let gamePhase = loadGame(named: mapName) {
            
            let height = gamePhase["height"] as? Int ?? 20
            let width  = gamePhase["width"] as? Int ?? 15
    
            if let layers = gamePhase["layers"] as? [[String:Any?]]{
                for layer in layers {
                    if let data = layer["data"] as? [Int] {
                        for (index, obj) in data.reversed().enumerated() {
                            
                            let spriteSize = CGSize(width: spriteWidth, height: spriteHeight)
                            self.delegate?.nodeForMatrix(mapHeight:  height,mapWidth:  width,index: index, objCode: obj, spriteSize: spriteSize)
                            
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
