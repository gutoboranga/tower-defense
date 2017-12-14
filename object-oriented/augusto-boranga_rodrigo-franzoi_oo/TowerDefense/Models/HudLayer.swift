//
//  HudLayer.swift
//  TowerDefense
//
//  Created by Rodrigo Franzoi Scroferneker on 28/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import SpriteKit

protocol HudLayerDelegate {
    func startRound()
}

class HudLayer: SKSpriteNode, ButtonDelegate{
    
    private let btnNames = ["speed", "damage", "range", "doubleShot"]
    
    private var buttons    : [ButtonNode] = []
    private var playButton : ButtonNode
    
    private var state      : GameStateMachine = .idle
    
    private var scoreLabel : SKLabelNode = SKLabelNode()
    private var coinsLabel : SKLabelNode = SKLabelNode()
    
    public var selectedButton : ButtonNode?
    public var delegate       : HudLayerDelegate!

    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        self.playButton = ButtonNode(texture: SKTexture(imageNamed: "play_icon"), size: CGSize(width: 128, height: 64))
        self.playButton.position = CGPoint(x: 88, y: 906)
        self.playButton.name = "Play"
        
        super.init(texture: texture, color: color, size: size)
        
        self.scoreLabel = createSKLabel(text: "Score: 0", position: CGPoint(x: 300, y: 906), fontName: "CourierNewPSMT", fontSize: 24.0)
        self.coinsLabel = createSKLabel(text: "Coins: 0", position: CGPoint(x: 600, y: 906), fontName: "CourierNewPSMT", fontSize: 24.0)
        
        self.zPosition = 10
        self.playButton.delegate = self
        
        for index in 0...3 {
            let button = ButtonNode(texture: SKTexture(imageNamed: btnNames[index] + "_2x"), size: CGSize(width: 64, height: 64))
            button.name = btnNames[index]
            button.color = NSColor.white
            button.delegate = self
            button.position = CGPoint(x: 46, y: 828 - (index * 64) - (30 * index))
            self.buttons.append(button)
            addChild(button)
        }
        
        addChild(playButton)
        addChild(coinsLabel)
        addChild(scoreLabel)
    }
    
    func createSKLabel(text: String, position: CGPoint, fontName: String, fontSize: CGFloat) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        
        label.position = position
        label.fontName = fontName
        label.fontSize = fontSize
        
        return label
    }
    
    override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        for node in self.nodes(at: point) {
            
            if !playButton.isSelected() || (node.name == "Play" && !playButton.isSelected()) {
                node.mouseDown(with: event)
            }
        }
    }
    
    public func setDeselectedButton(buttonNode: ButtonNode) {
        if selectedButton?.name == buttonNode.name {
            selectedButton = nil
        }
    }
    
    public func setSelectedButton(buttonNode: ButtonNode) {
        selectedButton = buttonNode
        for button in buttons {
            if button.name != buttonNode.name {
                button.deselect()
            }
        }
        
        if buttonNode.name == "Play" {
            self.delegate.startRound()
        }
    }
    
    
    public func setScore(newScore: Int) {
        self.scoreLabel.text = "Score: " + newScore.description
    }
    
    
    public func setCoins(newCoins: Int) {
        self.coinsLabel.text = "Coins: " + newCoins.description
    }
    
    public func setState(newState: GameStateMachine) {
        if state != newState {
            self.state = newState
            switch newState {
            case .idle:
                self.playButton.deselect()
            case .playing:
                break
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
