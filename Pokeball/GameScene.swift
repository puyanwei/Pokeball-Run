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
    var scoreLabel: SKLabelNode!
    var monTimer : Timer?
    var rocketTimer : Timer?
    var isIdleTimerDisabled: Bool { return true }
    var yourScore : SKLabelNode?

    var gameInt = 10
    var gameTimer = Timer()
   

    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    var yAcceleration: CGFloat = 0
    
    let pokeballCategory : UInt32 = 0x1 << 1
    let monCategory : UInt32 = 0x1 << 2
    let rocketCategory: UInt32 = 0x1 << 3
    
    var score = 0
    
    override func didMove(to view: SKView) {
        
        createPokeball ()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self

        startTimers ()
        title()
        background ()
        label ()
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.50 + self.xAcceleration * 0.50
                self.yAcceleration = CGFloat(acceleration.y) * 0.50 + self.yAcceleration * 0.50
            }
        }
    }
   
    func label() {
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel?.zPosition = 1
        scoreLabel?.fontName = "AmericanTypewriter-Bold"
        scoreLabel?.fontSize = 36
        scoreLabel?.fontColor = UIColor.white
    }
    
    
    func background () {
        let bgImage = SKSpriteNode(imageNamed : "pokeback")
        bgImage.position = CGPoint(x: self.frame.size.width/2, y: self.size.height/2)
        bgImage.zPosition = 0
    }
    
    func createPokeball () {
        pokeball = SKSpriteNode(imageNamed: "pokeball")
        pokeball?.physicsBody?.categoryBitMask = pokeballCategory
        pokeball?.physicsBody?.contactTestBitMask = monCategory
        pokeball.position = CGPoint(x: self.frame.size.width/2, y: self.size.height/2)
//        pokeball.size = CGSize(width: 50, height: 50)
        self.addChild(pokeball)
        
        pokeball.physicsBody = SKPhysicsBody(texture: pokeball.texture!,
                                             size: pokeball.texture!.size())
        pokeball.physicsBody?.usesPreciseCollisionDetection = true
        
        pokeball.zPosition = 1
    }
    
    
    func title() {
        level = SKLabelNode(text: "Makers4Lyf")
        level.position = CGPoint(x:150, y: self.frame.size.height - 60)
        level.fontName = "AmericanTypewriter-Bold"
        level.fontSize = 36
        level.fontColor = UIColor.white
        
        self.addChild(level)
        
        level.zPosition = 1
    }
    
    func createMon() {
        let mon = SKSpriteNode(imageNamed: "pikachu")
        mon.physicsBody = SKPhysicsBody(rectangleOf: mon.size)
        mon.physicsBody?.categoryBitMask = monCategory
        mon.physicsBody?.contactTestBitMask = pokeballCategory
//        mon.size = CGSize(width: 60, height: 60)
        addChild(mon)
        
        let height = frame.height
        let width = frame.width
        
        let randomPosition = CGPoint(x:CGFloat(arc4random()).truncatingRemainder(dividingBy: width),
                                     y: CGFloat(arc4random()).truncatingRemainder(dividingBy: height))
        
        mon.position = randomPosition
        mon.zPosition = 1
    }
    
    func createRocket() {
        let rocket = SKSpriteNode(imageNamed: "rocket")
        rocket.physicsBody = SKPhysicsBody(rectangleOf: rocket.size)
        rocket.physicsBody?.categoryBitMask = rocketCategory
        rocket.physicsBody?.contactTestBitMask = pokeballCategory
        //rocket.size = CGSize(width: 70, height: 70)
        addChild(rocket)
        
        let height = frame.height
        let width = frame.width
        
        let randomPosition = CGPoint(x:CGFloat(arc4random()).truncatingRemainder(dividingBy: width),
                                     y: CGFloat(arc4random()).truncatingRemainder(dividingBy: height))
        
        rocket.position = randomPosition
        rocket.zPosition = 1
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
        pokeball?.physicsBody?.applyForce(CGVector(dx: 0, dy: 0))
        
        let touch = touches.first
        if let location = touch?.location(in: self){
            let theNodes = nodes(at: location)
            
            for node in theNodes {
                if node.name == "ash" {
                    //Restart Game
                    
                    self.removeAllChildren()
                    title()
                    label()
                    yourScore?.removeFromParent()
                    self.removeAllActions()
                    self.scene?.removeFromParent()
                    scene?.isPaused = false
                    yourScore?.removeFromParent()
                    score = 0
                    scoreLabel?.text = "Score: \(score)"
                    background ()
                    scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
                    startTimers()
                    createPokeball()
                }
                
            }
        }
    }
    
    func removeRocket() {
        // Remove all sprites named "stars"
        self.enumerateChildNodes(withName: "rocket") {
            node, stop in
            node.removeFromParent();
        }
        
    }
    
    func removeMon() {
        // Remove all sprites named "stars"
        self.enumerateChildNodes(withName: "pikachu") {
            node, stop in
            node.removeFromParent();
        }
        
    }
    
    override func didSimulatePhysics() {
        pokeball.position.x += xAcceleration * 35
        pokeball.position.y += yAcceleration * 35
        
        if pokeball.position.x < -20 {
            pokeball.position = CGPoint(x: self.size.width + 20, y: pokeball.position.y)
        }else if pokeball.position.x > self.size.width + 20 {
            pokeball.position = CGPoint(x: -20, y: pokeball.position.y)
        }
        
        if pokeball.position.y < -20 {
            pokeball.position = CGPoint(x: pokeball.position.x, y: self.size.height + 20)
        }else if pokeball.position.y > self.size.height + 20 {
            pokeball.position = CGPoint(x:pokeball.position.x , y: -20)
        }
        
        
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
            gameOver()
        }
        if contact.bodyB.categoryBitMask == rocketCategory {
            gameOver()
        }
        
    }
    
    func gameOver() {
        scene?.isPaused = true
//        start = true
        
        monTimer?.invalidate()
        rocketTimer?.invalidate()
        
        yourScore = SKLabelNode(text: "Final score: \(score)")
        yourScore?.position = CGPoint(x: 400, y: 800)
        yourScore?.zPosition = 1
        yourScore?.fontSize = 100
        if yourScore != nil {
        addChild(yourScore!)
        }
        
        let ashButton = SKSpriteNode(imageNamed: "ash")
        ashButton.position = CGPoint(x: 360, y: 500)
        ashButton.name = "ash"
        ashButton.zPosition = 1
        addChild(ashButton)
        
    }
}


