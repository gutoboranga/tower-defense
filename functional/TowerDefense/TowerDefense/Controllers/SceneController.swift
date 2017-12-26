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

struct Tower {
    var posX : Int
    var posY : Int
    var life : Int = 100
}

struct Enemy {
    var posX : Int
    var posY : Int
    var life : Int = 100
}

class SceneController: NSViewController {
    
    @IBOutlet var skView: SKView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Aqui é onde a mágica começa
        
        print("> will create matrix")
        
        // matriz do mapa do jogo
        var matrix : [[Int]] = Array(repeating: Array(repeating: 0, count: 15), count: 20)
        matrix = matrix.map({
            $0.map({ _ in 0 })
        })
        
        print(matrix)
        
        // lista de waves do jogo
        let waves = [
            // (number of enemies, amount of money available)
             (1 , 500),
             (2 , 500),
             (3 , 500)
        ]
        
        // estado inicial do jogo, que será usado no reduce das waves
        let initialState : [String : Any] = [
            "castleLife" : 100,
            "towers" : [Tower](),
            "matrix" : matrix
            ]
        
//        print("> will enter main reduce")
        
        let result = run(waves: waves, state: initialState)
        
//        let finalResult = waves.reduce(initialState, { (currentState, wave) in
//            let x = currentState
//            return x
//        })

    }
    
    func run(waves : Array<(Int, Int)>, state: [String : Any]) -> [String : Any] {
        if waves.count == 0 || state["castleLife"] as! Int == 0 {
            print("> Game over")
            return state
        }
        
        print("> run: " + String(waves.count))
        let wave = waves[0]
        
        return run(waves: Array(waves.dropFirst()), state: play(
                wave: wave, state: setup(
                    wave: wave, state: state
                )
            )
        )
    }
    
    func setup(wave : (Int, Int), state: [String : Any]) -> [String : Any] {
        let scene = createPlayScene(wave: wave, state: state) as! SetupScene
        self.present(scene: scene)
        
        // aqui deve iterar várias vezes pegando input do usuario
        // --- wave x ---
        // a -> add tower
        // r -> remove tower
        // p -> play
        
        // se 'a',  -> pedir posição x, y e orientação da torre
        //          -> criar torre c os dados
        //          -> scene.addTower() com a nova torre
        //          -> atualizar na scene.matrix a posição da torre
        //          -> reloadMap() pra refletir as adições
        
        // se 'r',  -> pedir posição x, y da torre
        //          -> criar obj torre c os dados
        //          -> removeTower() com a torre
        //          -> atualizar na scene.matrix a posição da torre removida
        //          -> reloadMap() pra refletir as adições
        
        // se 'p',  -> break na iteração
        //          -> return scene.state, que é o estado atualizado da wave
        
        return scene.play()
    }
    
    func play(wave : (Int, Int), state: [String : Any]) -> [String : Any] {
        let scene = createPlayScene(wave: wave, state: state)
        self.present(scene: scene)
        
        return scene.play()
    }
    
    func createPlayScene(wave: (Int, Int), state: [String : Any]) -> PlayScene {
        if let scene = GKScene(fileNamed: "PlayScene") {
            if let sceneNode = scene.rootNode as! PlayScene? {
                sceneNode.scaleMode = .aspectFill

                sceneNode.wave = wave
                sceneNode.state = state

                return sceneNode
            }
        }
        return PlayScene()
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
    
//    func endOfGame(won: Bool, score: Int) {
//        let result = EndOfGame(didWin: won)
//
//        if let endScene = createScene(name: "EndScene") as! EndScene? {
//            endScene.setDelegate(delegate: self)
//            endScene.setTitle(title: result.title)
//            endScene.setDescription(description: result.description)
//            endScene.setScore(score: score)
//
//            self.present(scene: endScene)
//        }
//    }
}
