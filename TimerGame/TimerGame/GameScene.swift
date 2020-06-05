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
    
    var gamemode: Int!
    
    var gameLogo: SKLabelNode!
    var playButton: SKShapeNode!
    var newPlayButton: SKShapeNode!
    var bestScore: SKLabelNode!
    var backButton: SKLabelNode!
    var normalGame: SKLabelNode!
    var tenGameMode: SKLabelNode!
    var gameBG: SKShapeNode!
    var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
    var gameExplainText: SKLabelNode!
    var redSquare: SKShapeNode!
    var redSquare1: SKShapeNode!
    var redSquare2: SKShapeNode!
    var redSquare3: SKShapeNode!
    var redSquare4: SKShapeNode!
    var redSquare5: SKShapeNode!
    var redSquare6: SKShapeNode!
    var redSquare7: SKShapeNode!
    var redSquare8: SKShapeNode!
    var redSquare9: SKShapeNode!
    
    var nextTime: Double?
    var timeExtention: Double = 0.15
    
    var startButton: SKLabelNode!
    var captureTimeButton: SKLabelNode!
    var durationDisplay: SKLabelNode!
    var countdownEnd: TimeInterval?
    var countupStart: TimeInterval?
    
    
    func makeButton(text: String, position: CGPoint) -> SKLabelNode {
        let button = SKLabelNode()
        button.color = SKColor.white
        button.fontSize = 30
        button.position = position
        button.text = text
        return button
    }
    
    
    override func didMove(to view: SKView) {
        initializeMenu()
//        startButton = makeButton(text: "Start", position: CGPoint(x: 0, y: 200))
//        addChild(startButton)
//
//        captureTimeButton = makeButton(text: "Capture Time", position: CGPoint(x: 0, y: 0))
//        addChild(captureTimeButton)
//
//        durationDisplay = makeButton(text: "0 Seconds", position: CGPoint(x: 0, y: -200))
//        addChild(durationDisplay)
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
                    normalGameFunc()
                    gamemode = 0
                    self.backButton.isHidden = true
                    self.normalGame.isHidden = true
                    self.tenGameMode.isHidden = true
                    self.durationDisplay.isHidden = false
                    self.startButton.isHidden = false //
                    newPlayButton = SKShapeNode()
                    newPlayButton.name = "newplay_button"
                    newPlayButton.zPosition = 1
                    newPlayButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
                    newPlayButton.fillColor = SKColor.cyan
                    
                    let topCorner = CGPoint(x: -50, y: 50)
                    let bottomCorner = CGPoint(x: -50, y: -50)
                    let middle = CGPoint(x: 50, y: 0)
                    let path = CGMutablePath()
                    path.addLines(between: [topCorner, bottomCorner, middle])
                    newPlayButton.path = path
                    self.addChild(newPlayButton)
                    for touch in touches {
                        print("check 1")
                        // THIS CHECK GOES THROUGH BUT IT ENDS THERE
                        let location1 = touch.location(in: self)
                        for node in nodes(at: location1) {
                            print("check 2")
                            // FOR SOME REASON IT WONT GET TO THIS POINT IN THE CODE, AND ITS LATE AT NIGHT AND WONT WORK
                            if node == startButton && countdownEnd == nil && countupStart == nil, let timestamp = event?.timestamp {
                                countdownEnd = timestamp + Double.random(in: 1.0...4.0)
                                durationDisplay.text = "Wait For The Color Change"
                                print("start button clicked")
                            } else if node == redSquare, let unwrappedStart = countupStart, let timestamp = event?.timestamp {
                                let duration = timestamp - unwrappedStart
                                durationDisplay.text = "\(String(format:"%.4f", arguments: [duration])) seconds"
                                countupStart = nil
                                redSquare.fillColor = SKColor.green
                            } else if node == redSquare && countdownEnd != nil {
                                durationDisplay.text = "Too Soon"
                                countdownEnd = nil
                            }
                        }
                    }
                } else if node.name == "10_game_mode" {
                    tenGameModeFunc()
                    gamemode = 1
                    self.backButton.isHidden = true
                    self.normalGame.isHidden = true
                    self.tenGameMode.isHidden = true
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
        if gamemode == 0 {
            if let unwrappedCountdownEnd = countdownEnd, currentTime >= unwrappedCountdownEnd {
                countupStart = currentTime
                countdownEnd = nil
            }
            if let countupStart = countupStart {
                let duration = currentTime - countupStart
                durationDisplay.text = "\(String(format: "%.1f", arguments: [duration])) seconds"
            }
        } else if gamemode == 1 {

        }
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
    
//    private func createGameBoard(width: Int, height: Int) {
//        gameBG
//        let cellWidth: CGFloat = CGFloat(width) / 20
//        let cellHeight: CGFloat = CGFloat(height) / 40.0
//        let numRows = 20
//        let numCols = 10
//        var x = CGFloat(width / -2) + (cellWidth / 2)
//        var y = CGFloat(height / 2) - (cellHeight / 2)
//        //for loop for cell creation
//        for i in 0...numRows - 1 {
//            for j in 0...numCols - 1 {
//                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellHeight))
//                cellNode.strokeColor = SKColor.red
//                cellNode.zPosition = 2
//                cellNode.position = CGPoint(x: x, y: y)
//                gameArray.append((node: cellNode, x: i, y: j))
//                gameBG.addChild(cellNode)
//
//                x += cellWidth
//            }
//            x = CGFloat(width / -2) + (cellWidth / 2)
//            y -= cellWidth
//        }
//    }
    
    func normalGameFunc() {
        gameExplainText = SKLabelNode(fontNamed: "PalatinoBoldItalic")
        gameExplainText.zPosition = 1
        gameExplainText.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        gameExplainText.fontSize = 25
        gameExplainText.fontColor = SKColor.red
        gameExplainText.text = "CLICK THE BUTTON WHEN IT TURNS GREEN"
        self.addChild(gameExplainText)
        
        startButton = makeButton(text: "Start", position: CGPoint(x: 0, y: 250))
        addChild(startButton)
        
        captureTimeButton = makeButton(text: "Capture Time", position: CGPoint(x: 0, y: 200))
        addChild(captureTimeButton)
        
        durationDisplay = makeButton(text: "0 Seconds", position: CGPoint(x: 0, y: -200))
        addChild(durationDisplay)
        
        redSquare = SKShapeNode()
        redSquare.name = "red_square"
        redSquare.zPosition = 1
        redSquare.position = CGPoint(x: 0, y: 0)
        redSquare.fillColor = SKColor.red
        
        let topleftCorner = CGPoint(x: -50, y: 50)
        let bottomleftCorner = CGPoint(x: -50, y: -50)
        let toprightCorner = CGPoint(x: 50, y: 50)
        let bottomrightCorner = CGPoint(x: 50, y: -50)
        let path = CGMutablePath()
        path.addLines(between: [topleftCorner, bottomleftCorner, bottomrightCorner, toprightCorner])
        redSquare.path = path
        self.addChild(redSquare)
        
    }
    
    func tenGameModeFunc() {
        gameExplainText = SKLabelNode(fontNamed: "PalatinoBoldItalic")
        gameExplainText.zPosition = 1
        gameExplainText.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        gameExplainText.fontSize = 25
        gameExplainText.fontColor = SKColor.cyan
        gameExplainText.text = "CLICK EVERY BUTTON AS FAST AS YOU CAN"
        self.addChild(gameExplainText)
        
        startButton = makeButton(text: "Start", position: CGPoint(x: 0, y: 200))
        addChild(startButton)
        
        captureTimeButton = makeButton(text: "Capture Time", position: CGPoint(x: 0, y: (frame.size.height / 2) - 225))
        addChild(captureTimeButton)
        
        durationDisplay = makeButton(text: "0 Seconds", position: CGPoint(x: 0, y: (frame.size.height / 2) - 255))
        addChild(durationDisplay)

        redSquare = SKShapeNode()
        redSquare.name = "red_square"
        redSquare.zPosition = 1
        redSquare.position = CGPoint(x: 0, y: 0)
        redSquare.fillColor = SKColor.red
        
        redSquare1 = SKShapeNode()
        redSquare1.name = "red_square1"
        redSquare1.zPosition = 1
        redSquare1.position = CGPoint(x: 0, y: 200)
        redSquare1.fillColor = SKColor.red
        
        redSquare2 = SKShapeNode()
        redSquare2.name = "red_square2"
        redSquare2.zPosition = 1
        redSquare2.position = CGPoint(x: 0, y: -200)
        redSquare2.fillColor = SKColor.red
        
        redSquare3 = SKShapeNode()
        redSquare3.name = "red_square3"
        redSquare3.zPosition = 1
        redSquare3.position = CGPoint(x: 200, y: 0)
        redSquare3.fillColor = SKColor.red
        
        redSquare4 = SKShapeNode()
        redSquare4.name = "red_square4"
        redSquare4.zPosition = 1
        redSquare4.position = CGPoint(x: -200, y: 0)
        redSquare4.fillColor = SKColor.red
        
        redSquare5 = SKShapeNode()
        redSquare5.name = "red_square5"
        redSquare5.zPosition = 1
        redSquare5.position = CGPoint(x: 200, y: 200)
        redSquare5.fillColor = SKColor.red
        
        redSquare6 = SKShapeNode()
        redSquare6.name = "red_square6"
        redSquare6.zPosition = 1
        redSquare6.position = CGPoint(x: 200, y: -200)
        redSquare6.fillColor = SKColor.red
        
        redSquare7 = SKShapeNode()
        redSquare7.name = "red_square7"
        redSquare7.zPosition = 1
        redSquare7.position = CGPoint(x: -200, y: -200)
        redSquare7.fillColor = SKColor.red
        
        redSquare8 = SKShapeNode()
        redSquare8.name = "red_square8"
        redSquare8.zPosition = 1
        redSquare8.position = CGPoint(x: -200, y: 200)
        redSquare8.fillColor = SKColor.red
        
        let topleftCorner = CGPoint(x: -50, y: 50)
        let bottomleftCorner = CGPoint(x: -50, y: -50)
        let toprightCorner = CGPoint(x: 50, y: 50)
        let bottomrightCorner = CGPoint(x: 50, y: -50)
        let path = CGMutablePath()
        path.addLines(between: [topleftCorner, bottomleftCorner, bottomrightCorner, toprightCorner])
        
        redSquare.path = path
        self.addChild(redSquare)
        
        redSquare1.path = path
        self.addChild(redSquare1)
        
        redSquare2.path = path
        self.addChild(redSquare2)
        
        redSquare3.path = path
        self.addChild(redSquare3)
        
        redSquare4.path = path
        self.addChild(redSquare4)
        
        redSquare5.path = path
        self.addChild(redSquare5)
        
        redSquare6.path = path
        self.addChild(redSquare6)
        
        redSquare7.path = path
        self.addChild(redSquare7)
        
        redSquare8.path = path
        self.addChild(redSquare8)
                
        print("ten gm")
    }
    
}
