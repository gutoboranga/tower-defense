//
//  MenuScene.swift
//  TowerDefense
//
//  Created by Augusto Boranga on 16/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

protocol MenuDelegate {
    func newGame()
    func quit()
}

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    var menuDelegate: MenuDelegate?
    
    private var newGameLabel : SKLabelNode?
    private var quitLabel : SKLabelNode?
    private var selectedLabel : SKLabelNode?
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        self.newGameLabel = self.childNode(withName: "//newGameLabel") as? SKLabelNode
        self.quitLabel = self.childNode(withName: "//quitLabel") as? SKLabelNode
    }
    
    override func mouseDown(with event: NSEvent) {
        self.selectedLabel = nil
        
        let point = event.location(in: self)
        
        for node in self.nodes(at: point) {
            
            if let labelNode = node as? SKLabelNode {
                
                switch labelNode {
                case self.newGameLabel!, self.quitLabel!:
                    self.selectedLabel = labelNode
                    self.selectedLabel?.fontSize += 6
                default:
                    break
                }
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if let label = self.selectedLabel {
            self.selectedLabel?.fontSize -= 6
            
            switch label {
            case self.newGameLabel!:
                self.removeFromParent()
                self.menuDelegate!.newGame()
            case self.quitLabel!:
                self.removeFromParent()
                self.menuDelegate!.quit()
            default:
                break
            }
        }
    }
}
