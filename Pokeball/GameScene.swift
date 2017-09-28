//
//  GameScene.swift
//  Space Game
//
//  Created by Rolando Sorbelli on 25/09/2017.
//  Copyright © 2017 Rolando Sorbelli. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var pokeball: SKSpriteNode!
    var level: SKLabelNode!
    var scoreLabel: SKLabelNode?
    var monTimer : Timer?
    var rocketTimer : Timer?
    
    var gameInt = 10
    var gameTimer = Timer()
    var yourScore : SKLabelNode?

    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    var yAcceleration: CGFloat = 0
    
    let pokeballCategory : UInt32 = 0x1 << 1
    let monCategory : UInt32 = 0x1 << 2
    let rocketCategory: UInt32 = 0x1 << 3
    
    var score = 0
    
    override func didMove(to view: SKView) {
        
        pokeball = SKSpriteNode(imageNamed: "pokeball")
        pokeball?.physicsBody?.categoryBitMask = pokeballCategory
        pokeball?.physicsBody?.contactTestBitMask = monCategory
        pokeball.position = CGPoint(x: self.frame.size.width/2, y: self.size.height/2)
        self.addChild(pokeball)
        
        pokeball.physicsBody = SKPhysicsBody(texture: pokeball.texture!,
                                               size: pokeball.texture!.size())
        pokeball.physicsBody?.usesPreciseCollisionDetection = true
        
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode

        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        level = SKLabelNode(text: "Level: Makers4Lyf")
        level.position = CGPoint(x:200, y: self.frame.size.height - 60)
        level.fontName = "AmericanTypewriter-Bold"
        level.fontSize = 36
        level.fontColor = UIColor.white
        
        self.addChild(level)
        
        startTimers ()
        createRocket()
        createMon()
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.50 + self.xAcceleration * 0.50
                self.yAcceleration = CGFloat(acceleration.y) * 0.50 + self.yAcceleration * 0.50
            }
        }
    }
    func createMon() {
        let mon = SKSpriteNode(imageNamed: "pikachu")
        mon.physicsBody = SKPhysicsBody(rectangleOf: mon.size)
        mon.physicsBody?.categoryBitMask = monCategory
        mon.physicsBody?.contactTestBitMask = pokeballCategory
        addChild(mon)
        
        let height = frame.height
        let width = frame.width
        
        let randomPosition = CGPoint(x:CGFloat(arc4random()).truncatingRemainder(dividingBy: width),
                                     y: CGFloat(arc4random()).truncatingRemainder(dividingBy: height))
        
        mon.position = randomPosition
    }
    
    func createRocket() {
        let rocket = SKSpriteNode(imageNamed: "rocket")
        rocket.physicsBody = SKPhysicsBody(rectangleOf: rocket.size)
        rocket.physicsBody?.categoryBitMask = rocketCategory
        rocket.physicsBody?.contactTestBitMask = pokeballCategory
        addChild(rocket)
        
        let height = frame.height
        let width = frame.width
        
        let randomPosition = CGPoint(x:CGFloat(arc4random()).truncatingRemainder(dividingBy: width),
                                     y: CGFloat(arc4random()).truncatingRemainder(dividingBy: height))
        
        rocket.position = randomPosition
    }
    
    func startTimers () {
        rocketTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            self.createRocket()
        })
        
        monTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.createMon()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pokeball?.physicsBody?.applyForce(CGVector(dx: 0, dy: 100_000))
        
        let touch = touches.first
        if let location = touch?.location(in: self){
            let theNodes = nodes(at: location)
            
            for node in theNodes {
                if node.name == "ash" {
                    //Restart Game
                    score = 0
                    node.removeFromParent()
                    yourScore?.removeFromParent()
                    scene?.isPaused = false
                    scoreLabel?.text = "Score: \(score)"
                    startTimers()
                }
                
            }
        }
    }
    
    override func didSimulatePhysics() {
        pokeball.position.x += xAcceleration * 35
        pokeball.position.y += yAcceleration * 35
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == monCategory {
            contact.bodyA.node?.removeFromParent()
            score += 1
            scoreLabel?.text = "Score: \(score)"
            
        }
        if contact.bodyB.categoryBitMask == monCategory {
            contact.bodyB.node?.removeFromParent()
            score += 1
            scoreLabel?.text = "Score: \(score)"
            
        }
        if contact.bodyA.categoryBitMask == rocketCategory {
//            contact.bodyA.node?.removeFromParent()
            gameOver()
        }
        if contact.bodyB.categoryBitMask == rocketCategory {
//            contact.bodyB.node?.removeFromParent()
            gameOver()
        }
    }
    
    func gameOver() {
        scene?.isPaused = true
        
        monTimer?.invalidate()
        rocketTimer?.invalidate()
        
        yourScore = SKLabelNode(text: "Final score: \(score)")
        yourScore?.position = CGPoint(x: 400, y: 800)
        yourScore?.fontSize = 100
        if yourScore != nil {
            addChild(yourScore!)
        }
        
        
        let ashButton = SKSpriteNode(imageNamed: "ash")
        ashButton.position = CGPoint(x: 360, y: 500)
        ashButton.name = "ash"
        addChild(ashButton)
        
    }
}


