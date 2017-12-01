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

class SceneController: NSViewController, MenuDelegate, EndDelegate, GameDelegate {
    
    @IBOutlet var skView: SKView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainMenu()
    }
    
    func createScene(name: String) -> SKScene? {
        // load 'GameScene.sks' as a GKScene. This provides gameplay related content
        if let scene = GKScene(fileNamed: name) {
            return scene.rootNode as! SKScene?
        }
        return SKScene()
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
    
    func newGame() {
        print("New game")
        
        let gameScene = GameScene(size: self.skView.scene!.size)
        gameScene.gameDelegate = self
        self.present(scene: gameScene)
    }
    
    func quit() {
        // TODO: Aqui deve fechar tudo
        print("Quit")
        exit(0)
    }
    
    func mainMenu() {
        print("Main menu")
        
        if let menuScene = createScene(name: "MenuScene") as! MenuScene? {
            menuScene.menuDelegate = self
            self.present(scene: menuScene)
        }
    }
    
    func endOfGame(won: Bool, score: Int) {
        print("End of game")
        
        var title : String = "Game over!"
        var description : String = "Mars was invaded :-("
        if won {
            title = "You win!"
            description = "You saved mars ;-D"
        }
        
        if let endScene = createScene(name: "EndScene") as! EndScene? {
            endScene.setDelegate(delegate: self)
            endScene.setTitle(title: title)
            endScene.setDescription(description: description)
            endScene.setScore(score: score)
            
            self.present(scene: endScene)
        }
    }
}
