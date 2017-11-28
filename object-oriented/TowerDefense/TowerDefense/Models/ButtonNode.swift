//
//  ButtonNode.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

protocol ButtonDelegate {
    func setSelectedButton(buttonNode: ButtonNode)
    func setDeselectedButton(buttonNode: ButtonNode)
}

class ButtonNode: SKSpriteNode {

    private var selected : Bool
    public var delegate : ButtonDelegate!
    
    init(texture: SKTexture?, size: CGSize) {
        
        self.selected = false
        
        super.init(texture: texture, color: .cyan, size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    override func mouseDown(with event: NSEvent) {
        self.selectButton()
    }
    
    func selectButton() {
        self.selected = !self.selected
        
        if selected {
            self.select()
        } else {
            self.deselect()
        }
    }
    
    private func select() {
        self.selected = true
        self.color = .yellow
        self.delegate.setSelectedButton(buttonNode: self)
        
        let action = SKAction.scale(to: 0.95, duration: 0.1)
        run(action)
        
    }
    
    public func deselect() {
        self.selected = false
        self.color = .cyan
        self.delegate.setDeselectedButton(buttonNode: self)
        
        let action = SKAction.scale(to: 1, duration: 0.1)
        run(action)
    }
    
    public func isSelected() -> Bool {
        return selected
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
