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
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    var yAcceleration: CGFloat = 0
    
    override func didMove(to view: SKView) {
        
    pokeball = SKSpriteNode(imageNamed: "pokeball")
    
    pokeball.position = CGPoint(x: self.frame.size.width/2, y: self.size.height/2)
    
    self.addChild(pokeball)
    
    pokeball.physicsBody = SKPhysicsBody(texture: pokeball.texture!,
                                           size: pokeball.texture!.size())
    pokeball.physicsBody?.usesPreciseCollisionDetection = true
    
    
        createMon()
        createMon()
        createMon()
        createMon()
        
        
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    self.physicsWorld.contactDelegate = self
    
    level = SKLabelNode(text: "Level: Makers4Lyf")
    level.position = CGPoint(x:200, y: self.frame.size.height - 60)
    level.fontName = "AmericanTypewriter-Bold"
    level.fontSize = 36
    level.fontColor = UIColor.white
    
    self.addChild(level)
        
        
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
        
        let height = frame.height
        let width = frame.width
        
        let randomPosition = CGPoint(x:CGFloat(arc4random()).truncatingRemainder(dividingBy: width),
                                     y: CGFloat(arc4random()).truncatingRemainder(dividingBy: height))
        //
        let mon = SKSpriteNode(imageNamed: "pikachu")
        mon.position = randomPosition
        addChild(mon)
    }
    
    
    
    override func didSimulatePhysics() {
        pokeball.position.x += xAcceleration * 35
        pokeball.position.y += yAcceleration * 35
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

