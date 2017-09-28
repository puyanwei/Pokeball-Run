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
        gameScene = nil
    }
    
    func testExample() {
        let childNode = gameScene.childNode(withName:"pokeball")
        print("Hello!")
        print(gameScene.childNode)
        if childNode != nil {
            XCTAssertTrue(true)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
