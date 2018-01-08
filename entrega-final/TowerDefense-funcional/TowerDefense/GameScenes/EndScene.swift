//
//  MenuScene.swift
//  TowerDefense
//
//  Created by Augusto Boranga on 16/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

protocol EndDelegate : MenuDelegate {
    func mainMenu()
}

import SpriteKit
import GameplayKit

class EndScene: SKScene {
    
    var endDelegate: EndDelegate?
    
    private var titleLabel : SKLabelNode?
    private var descriptionLabel : SKLabelNode?
    private var newGameLabel : SKLabelNode?
    private var mainMenuLabel : SKLabelNode?
    private var quitLabel : SKLabelNode?
    private var scoreLabel : SKLabelNode?
    private var selectedLabel : SKLabelNode?
    
    func setDelegate(delegate: EndDelegate) {
        self.endDelegate = delegate
    }
    
    func setTitle(title: String) {
        self.titleLabel?.text = title
    }
    
    func setDescription(description: String) {
        self.descriptionLabel?.text = description
    }
    
    func setScore(score: Int) {
        self.scoreLabel?.text = "Score: " + String(score)
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        self.titleLabel = self.childNode(withName: "//titleLabel") as? SKLabelNode
        self.descriptionLabel = self.childNode(withName: "//descriptionLabel") as? SKLabelNode
        self.newGameLabel = self.childNode(withName: "//newGameLabel") as? SKLabelNode
        self.mainMenuLabel = self.childNode(withName: "//mainMenuLabel") as? SKLabelNode
        self.quitLabel = self.childNode(withName: "//quitLabel") as? SKLabelNode
        self.scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
    }
    
    override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        let allNodes = self.nodes(at: point)
        
        let labelNodes = allNodes.filter({
            return $0.isMember(of: SKLabelNode.self)
        })
        
        let labelToSelect = labelNodes.first(where: nodeIsClickable)
        
        self.selectedLabel = labelToSelect as? SKLabelNode
    }
    
    func nodeIsClickable(node: SKNode) -> Bool {
        return node == self.newGameLabel! ||
               node == self.quitLabel! ||
               node == self.mainMenuLabel!
    }
    
    override func mouseUp(with event: NSEvent) {
        if let label = self.selectedLabel {
            self.selectedLabel?.fontSize -= 6
            
            switch label {
            case self.newGameLabel!:
                self.removeFromParent()
                self.endDelegate!.newGame()
            case self.mainMenuLabel!:
                self.removeFromParent()
                self.endDelegate!.mainMenu()
            case self.quitLabel!:
                self.removeFromParent()
                self.endDelegate!.quit()
            default:
                break
            }
        }
    }
}
