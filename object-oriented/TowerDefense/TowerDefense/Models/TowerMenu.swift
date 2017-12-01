//
//  TowerMenu.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 29/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

protocol TowerMenuDelegate {
    func rotate()
    func removeTower()
    func upgrade()
}

class TowerMenu: StandardBlock, ButtonDelegate {
    
    let btnNames = ["Remove", "Rotate", "Upgrade"]
    
    private var buttons : [ButtonNode] = []
    private var active : Bool
    private var level  : Int
    
    public var delegate : TowerMenuDelegate!
    
    init(size: CGSize) {
        self.level = 0
        self.active = false
        super.init(texture: nil, color: .clear, size: size)
        
        self.orientation = .up
        self.zPosition = 4
        self.activate()
    }
    
    public func activate() {
        if !self.active {
            self.active = true
            
            for index in 0...2 {
                let button = ButtonNode(texture: SKTexture(imageNamed: btnNames[index] + "_icon"), size: CGSize(width: 28, height: 28))
                button.zPosition = 10
                button.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                button.name = btnNames[index]
                button.delegate = self
                button.position = CGPoint(x: -size.width/2 - button.size.width/2 - 5, y: -(CGFloat(index - 1) * 32.0))
                self.buttons.append(button)
                if !(level == 3 && index == 2) {
                    addChild(button)
                }
            }
        }
    }
    
    public func disable(){
        self.active = false
        removeAllChildren()
        buttons.removeAll()
    }
    
    override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        for button in buttons {
            if active {
                if button.contains(point) {
                    button.mouseDown(with: event)
                }
            }
        }
    }
    
    // Buttons Delegate
    
    func setSelectedButton(buttonNode: ButtonNode) {
        
        if buttonNode.name == "Remove" {
            delegate.removeTower()
        } else if buttonNode.name == "Rotate" {
            delegate.rotate()
            rotateLeft()
        } else if buttonNode.name == "Upgrade" {
            delegate.upgrade()
        }
        
        let action = SKAction.wait(forDuration: 0.2)
        buttonNode.run(action) {
            buttonNode.deselect()
        }
    }
    
    func setDeselectedButton(buttonNode: ButtonNode) {
        
    }
    
    public func upgradeLevel() {
        self.level += 1
        
        if level >= 3 {
            self.buttons.last?.removeFromParent()
        }
    }
    
    public func isActive() -> Bool {
        return active
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
