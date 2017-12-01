//
//  MenuController.swift
//  TowerDefense
//
//  Created by Augusto Boranga on 16/11/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class SceneController: NSViewController, MenuDelegate {
    
    @IBOutlet var skView: SKView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let menuScene = createScene(name: "MenuScene") as! MenuScene? {
            menuScene.menuDelegate = self
            self.present(scene: menuScene)
        }
    }
    
    func createScene(name: String) -> SKScene? {
        // load 'GameScene.sks' as a GKScene. This provides gameplay related content
        if let scene = GKScene(fileNamed: name) {
            return scene.rootNode as! SKScene?
        }
        return SKScene()
    }
    
    func newGame() {
        let gameScene = GameScene(size: self.skView.scene!.size)
        self.present(scene: gameScene)
    }
    
    func present(scene : SKScene) {
        // scale correctly
        scene.scaleMode = .aspectFill
        
        // present the scene
        if let view = self.skView {
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
    
    func quit() {
        // TODO: Aqui deve fechar tudo
        print("Quit")
    }
}
