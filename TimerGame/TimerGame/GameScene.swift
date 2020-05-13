//
//  GameScene.swift
//  TimerGame
//
//  Created by Matthew Silletti on 5/7/20.
//  Copyright © 2020 Matthew Silletti. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var gameLogo: SKLabelNode!
    var playButton: SKShapeNode!
    var bestScore: SKLabelNode!
    var backButton: SKLabelNode!
    var normalGame: SKLabelNode!
    var tenGameMode: SKLabelNode!
    
    
    
    override func didMove(to view: SKView) {
        initializeMenu()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "play_button" {
                    gameModeSelect()
                } else if node.name == "back_button" {
                    initializeMenu()
                    self.backButton.isHidden = true
                    self.normalGame.isHidden = true
                    self.tenGameMode.isHidden = true
                } else if node.name == "normal_game" {
                    //normalGame()
                } else if node.name == "10_game_mode" {
                    //tenGameMode()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    private func initializeMenu() {
        gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        gameLogo.fontSize = 60
        gameLogo.text = "Reflex Tester!"
        gameLogo.fontColor = SKColor.blue
        self.addChild(gameLogo)
        
        bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x: 0, y: gameLogo.position.y - 50)
        bestScore.fontSize = 40
        bestScore.text = "Fastest Time: 0"
        bestScore.fontColor = SKColor.lightGray
        bestScore.text = "Fastest Time: \(UserDefaults.standard.integer(forKey: "bestScore"))"
        self.addChild(bestScore)
        
        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton.fillColor = SKColor.cyan
        
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLines(between: [topCorner, bottomCorner, middle])
        playButton.path = path
        self.addChild(playButton)
        
//        self.backButton.isHidden = true
//        self.tenGameMode.isHidden = true
//        self.normalGame.isHidden = true
    }
    
    func gameModeSelect() {
        print("next menu")
        self.gameLogo.isHidden = true
        self.playButton.isHidden = true
        self.bestScore.isHidden = true
        
        backButton = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        backButton.zPosition = 1
        backButton.position = CGPoint(x: -250, y: (frame.size.height / 2) - 175)
        backButton.fontSize = 30
        backButton.text = "Back"
        backButton.fontColor = SKColor.blue
        backButton.name = "back_button"
        print("back to main")
        self.addChild(backButton)
        
        tenGameMode = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        tenGameMode.zPosition = 1
        tenGameMode.position = CGPoint(x: 0, y: backButton.position.y - 600)
        tenGameMode.fontSize = 40
        tenGameMode.fontColor = SKColor.lightGray
        tenGameMode.text = "10 Click Game"
        tenGameMode.name = "10_game_mode"
        self.addChild(tenGameMode)
        
        normalGame = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        normalGame.zPosition = 1
        normalGame.position = CGPoint(x: 0, y: backButton.position.y - 500)
        normalGame.fontSize = 40
        normalGame.fontColor = SKColor.lightGray
        normalGame.text = "Normal Game"
        normalGame.name = "normal_game"
        self.addChild(normalGame)
    }
}
