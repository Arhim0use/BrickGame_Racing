//
//  LevelManageTest.swift
//  Racing
//
//  Created by Chingisbek Anvardinov on 14.12.2024.
//

import Testing
import XCTest
import Foundation

@testable import Race

class LevelHandlerUnitTest: XCTestCase {
    let model = RacingModel()
    var lvlHandler: LevelHandler!
    
    override func setUpWithError() throws {
        model.level = 7
        model.speed = RacingDefines.speedArr[6]
        lvlHandler = LVLHandler(gameModel: model)
    }

    func testRestart() async throws {
        let levelBeforeRestart = model.score
        let speedBeforeRestart = model.speed
        
        lvlHandler.restart()
        
        XCTAssertNotEqual(levelBeforeRestart, model.level)
        XCTAssertNotEqual(speedBeforeRestart, model.speed)
        
        XCTAssertEqual(model.speed, RacingDefines.speedArr[0])
        XCTAssertEqual(model.level, 1)
    }
    
    func testLevelUp() async throws {
        model.score = 26
        let levelBefore = model.level
        let speedBefore = model.speed
        
        lvlHandler.levelUp()
        
        let levelAfter = model.level
        let speedAfter = model.speed
        
        XCTAssertNotEqual(levelBefore, levelAfter)
        XCTAssertNotEqual(speedBefore, speedAfter)
        
        XCTAssertEqual(model.speed, RacingDefines.speedArr[1])
        XCTAssertEqual(model.level, 2)
    }
    
    func testNotLevelUp() async throws {
        model.score = 26
        lvlHandler.levelUp()
        
        let levelBefore = model.level
        let speedBefore = model.speed
        
        model.score = 28

        lvlHandler.levelUp()
        
        let levelAfter = model.level
        let speedAfter = model.speed
        
        XCTAssertEqual(levelBefore, levelAfter)
        XCTAssertEqual(speedBefore, speedAfter)
        
        XCTAssertEqual(model.speed, RacingDefines.speedArr[1])
        XCTAssertEqual(model.level, 2)
    }
    
    func testAtMaxLevel() async throws {
        model.level = 10
        model.speed = RacingDefines.speedArr[9]
        model.score = 2990
        lvlHandler.levelUp()
        
        let levelBefore = model.level
        let speedBefore = model.speed
        
        model.score = 3000

        lvlHandler.levelUp()
        
        let levelAfter = model.level
        let speedAfter = model.speed
        
        XCTAssertEqual(levelBefore, levelAfter)
        XCTAssertEqual(speedBefore, speedAfter)
        
        XCTAssertEqual(model.speed, RacingDefines.speedArr[9])
        XCTAssertEqual(model.level, 10)
    }
}

class BaseLevelHandlerUnitTest: XCTestCase {
    let model = RacingModel()
    var lvlHandler: LevelHandler!
    
    override func setUpWithError() throws {
        model.level = 1
        model.speed = RacingDefines.speedArr[6]
        lvlHandler = LevelHandler(gameModel: model)
    }
    
    func testLvLUp() async throws {
        model.score = 40
        let levelBeforeRestart = model.level
        let speedBeforeRestart = model.speed
        
        lvlHandler.levelUp()
        
        XCTAssertNotEqual(speedBeforeRestart, model.speed)
        XCTAssertNotEqual(levelBeforeRestart, model.level)
        XCTAssertEqual(56, model.speed)
        XCTAssertEqual(2, model.level)
    }
}
