//
//  PokeballTests.swift
//  PokeballTests
//
//  Created by Rolando Sorbelli on 26/09/2017.
//  Copyright © 2017 Rolando Sorbelli. All rights reserved.
//

import XCTest
@testable import Pokeball

class PokeballTests: XCTestCase {
    
    var gameScene:GameScene!
    
    override func setUp() {
        super.setUp()
        
        gameScene = GameScene()
        
    }
    
    override func tearDown() {
        super.tearDown()
//        gameScene = nil
    }
    
    func testPokeball() {
        let pokeball = GameScene()
        print("Hello!")
        print(pokeball)
//        if pokeball != nil {
        XCTAssertNotNil(pokeball)
//        } else {
//            print("This test does not pass! You suck!")
//        }
    }
    
    
    func testScoreLabel() {
        let scoreLabel = gameScene.childNode(withName: "ScoreLabel")
        print("Hello!3")
        print(gameScene.scoreLabel)
            XCTAssertNil(scoreLabel)
    }
    
    func testLevel() {
        let level = gameScene.childNode(withName: "Level: Makers4Lyf")
        print("Hello!2")
        print(gameScene.level)
        if level != nil {
            XCTAssert(true)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
