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

class MenuController: NSViewController, MenuDelegate {
    
    let sceneName = "MenuScene"
    @IBOutlet var skView: SKView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureScene(sceneName: self.sceneName)
    }
    
    func configureScene(sceneName: String) {
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: sceneName) {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! MenuScene? {
                
                sceneNode.scaleMode = .aspectFill
                sceneNode.menuDelegate = self
                
                // Present the scene
                if let view = self.skView {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    func newGame() {
        print("New Game")
        //let game = Game()
        //var gameController = GameController(newGame: game)
        
        let gameScene = GameScene(size: skView.scene!.size)
        gameScene.scaleMode = .aspectFill
                
        // Present the scene
        if let view = self.skView {
            view.presentScene(gameScene)
            
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
