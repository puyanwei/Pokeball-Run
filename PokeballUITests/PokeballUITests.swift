//
//  PokeballUITests.swift
//  PokeballUITests
//
//  Created by Rolando Sorbelli on 26/09/2017.
//  Copyright © 2017 Rolando Sorbelli. All rights reserved.
//

import XCTest

class PokeballUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScore() {
        
        let app = XCUIApplication()
        let scoreLabel = app.otherElements["Score: 0"]
        XCTAssert(scoreLabel.exists)
    }
    
    func testLevel(){
        let app = XCUIApplication()
        let level = app.otherElements["Level: Makers4Lyf"]
        XCTAssert(level.exists)
    }
    
    func testPikachuSpriteExists(){
        let app = XCUIApplication()
        let pikachuSprite = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element
        XCTAssert(pikachuSprite.exists)
    }
    
    func testTeamRocketSpriteExists(){
        let app = XCUIApplication()
        let teamRocketSprite = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element
        XCTAssert(teamRocketSprite.exists)
    } // Test a bit redundant since every sprite is the same variable.
    
    func testPokeballSpriteExists(){
        let app = XCUIApplication()
        let pokeballSprite = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element
        XCTAssert(pokeballSprite.exists)
    } // Test a bit redundant since every sprite is the same variable.
}
