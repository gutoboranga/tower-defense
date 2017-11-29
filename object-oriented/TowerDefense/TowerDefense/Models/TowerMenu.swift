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

class TowerMenu: SKSpriteNode, ButtonDelegate {
    
    let btnNames = ["Remove", "Rotate", "Upgrade"]
    
    private var buttons : [ButtonNode] = []
    private var orientation : ObjectFaceOrientation
    private var active : Bool
    public var delegate : TowerMenuDelegate!
    
    init(size: CGSize) {
        
        self.active = false
        self.orientation = .up
        super.init(texture: nil, color: .clear, size: size)
        self.zPosition = 4
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.activate()
    }
    
    public func activate() {
        if !self.active {
            self.active = true
            
            for index in 0...2 {
                let button = ButtonNode(texture: nil, size: CGSize(width: 28, height: 28))
                button.zPosition = 10
                button.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                button.name = btnNames[index]
                button.delegate = self
                button.position = CGPoint(x: -size.width/2 - button.size.width/2 - 5, y: -(CGFloat(index - 1) * 32.0))
                self.buttons.append(button)
                addChild(button)
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
    
    public func isActive() -> Bool {
        return active
    }
    
    private func rotateLeft() {
        switch self.orientation {
        case .up:
            self.setOrientation(to: .left)
        case .right:
            self.setOrientation(to: .up)
        case .down:
            self.setOrientation(to: .right)
        case .left:
            self.setOrientation(to: .down)
        }
    }
    
    public func setOrientation(to newOrientation:ObjectFaceOrientation) {
        if self.orientation != newOrientation {
            self.zRotation = CGFloat(newOrientation.rawValue).degreesToRadians()
            self.orientation = newOrientation
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
