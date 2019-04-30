//
//  GameScene.swift
//  Pong
//
//  Created by Thomas De Lange on 22-04-18.
//  Copyright © 2018 Thomas De Lange. All rights reserved.
//

import SpriteKit
import GameplayKit

var ball = SKSpriteNode()
var player = SKSpriteNode()
var enemy = SKSpriteNode()
var topScoreLabel = SKLabelNode()
var bottomScoreLabel = SKLabelNode()

let brain = NeuralNetwork(input: 1, hidden: 6, output: 1)

let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width

var screenCenter = CGPoint()

var score = [Int]()

let enoughTimesTrained = 8000
var timesTrained = 0

class GameScene: SKScene {
        
    override func didMove(to view: SKView) {
        
        screenCenter = CGPoint(x: 375, y: 0)
    
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        player = self.childNode(withName: "player") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        topScoreLabel = self.childNode(withName: "topScore") as! SKLabelNode
        bottomScoreLabel = self.childNode(withName: "bottomScore") as! SKLabelNode

        startGame()
        
    }
    
    func startGame() {
        
        if currentGameType == .twoPlayer{
            topScoreLabel.zRotation = CGFloat.pi
        }
        
        score = [0, 0]
        topScoreLabel.text = "\(score[1])"
        bottomScoreLabel.text = "\(score[0])"
        
        var direction : CGFloat
        let random = Int.random(min: 0, max: 1)
        if random == 1 {
            direction = 20
        }else {
            direction = -20
        }
        ball.physicsBody?.applyImpulse(CGVector(dx : direction, dy : 20))
    }
    
    func addScore(playerWhoWon : SKSpriteNode){
        
        ball.position = CGPoint(x: screenCenter.x, y: screenCenter.y)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        var direction : CGFloat
        let random = Int.random(min: 0, max: 1)
        if random == 1 {
            direction = 20
        }else {
            direction = -20
        }
        
        if playerWhoWon == player {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx : direction, dy : 20))
            
        }else if playerWhoWon == enemy{
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx : direction, dy : -20))
            
        }
        topScoreLabel.text = "\(score[1])"
        bottomScoreLabel.text = "\(score[0])"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            
            let location = touch.location(in : self)
            
            if currentGameType == .twoPlayer{
                if location.y > 0{
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    player.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            } else if currentGameType != .AI{
                player.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{

            let location = touch.location(in : self)
            
            if currentGameType == .twoPlayer{
                if location.y > 0{
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    player.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            }else if currentGameType != .AI{
                player.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        

        
        switch currentGameType{
        case .easy:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.3))
            break
            
        case .medium:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.0))
            break
            
        case .hard:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.7))
            break
            
        case .twoPlayer:
            break
            
        case .AI:
            player.run(SKAction.moveTo(x: ball.position.x, duration: 0.5))
            
            if (timesTrained < enoughTimesTrained){
                timesTrained = timesTrained + 1
                trainBrain()
            }
            
            if (timesTrained == enoughTimesTrained) {
                print("ENOUGH TRAINED")
            }
            
            enemy.run(SKAction.moveTo(x: calculateMoveTo() , duration: 0.0))
            break
        }
        
        if ball.position.y <= player.position.y - 70 {
            addScore(playerWhoWon: enemy)
        }else if ball.position.y >= enemy.position.y + 70{
            addScore(playerWhoWon: player)
        }
    }
    
    func trainBrain() {
        
        let inputArray = [Double(ball.position.x / 750) ]
        let targetArray = [Double(ball.position.x / 750) ]
        brain.train(inputArray: inputArray, targetArray: targetArray)
        
        //print("ball: \(ball.position.x), input: \(inputArray[0])")
        
    }
    
    func calculateMoveTo() -> CGFloat{
        let brainInput = [Double(ball.position.x / screenWidth) ]
        var brainArrayOutput = brain.guess(inputArray: brainInput)
        let brainCGFloatOutput : CGFloat = CGFloat(brainArrayOutput[0])
        
        let moveTo = brainCGFloatOutput * 750
        
        return moveTo
        
    }
}

