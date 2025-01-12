//
//  File.swift
//  Race
//
//  Created by Chingisbek Anvardinov on 18.12.2024.
//

import Testing
import XCTest

@testable import Race
import CommonBrickGame

class GaeInfoWrapperlUnitTest: XCTestCase {
    var wrapper: GameInfoWrapper!
    
    override func setUpWithError() throws {
        wrapper = GameInfoWrapper()
    }
    
    func testPauseStateSetter_0() async throws {
        let stateBefore = wrapper.gameState
        
        wrapper.gameState = .gameEnd
        
        let stateAfter = wrapper.gameState
        
        XCTAssertNotEqual(stateBefore, stateAfter)
        XCTAssertEqual(GameInfoWrapper.GameState.gameEnd, stateAfter)
        XCTAssertEqual(0, stateAfter.rawValue)
        XCTAssertEqual(RacingInt(wrapper.gameInfo.pause), RacingInt(stateAfter.rawValue))
    }
    
    func testPauseStateSetter_1() async throws {
        let stateBefore = wrapper.gameState
        
        wrapper.gameState = .gameRun
        
        let stateAfter = wrapper.gameState
        
        XCTAssertNotEqual(stateBefore, stateAfter)
        XCTAssertEqual(GameInfoWrapper.GameState.gameRun, stateAfter)
        XCTAssertEqual(1, stateAfter.rawValue)
        XCTAssertEqual(RacingInt(wrapper.gameInfo.pause), RacingInt(stateAfter.rawValue))
    }
    
    func testIsAllocate() async throws {
        XCTAssertTrue(wrapper.matrixIsAllocate())
    }
    
    func testDeinit() async throws {
        do {
            wrapper = GameInfoWrapper()
        }
    }
}

class UserActionUnitTest: XCTestCase {
    var action: UserAction!
    
    override func setUpWithError() throws {
        action = UserAction.action
    }
    
    func testChangeFromRawValue_0() async throws {
        let actionBefore = action
        
        action = UserAction.fromInput(UnicodeScalar("s").value)
        
        let actionAfter = action
        
        XCTAssertEqual(UserAction.start, actionAfter)
        XCTAssertNotEqual(actionBefore, actionAfter)
    }
    
    func testChangeFromRawValue_1() async throws {
        let actionBefore = action
        
        action = UserAction.fromInput(0x20)
        
        let actionAfter = action
        
        XCTAssertEqual(UserAction.action, actionAfter)
        XCTAssertEqual(actionBefore, actionAfter)
        XCTAssertTrue(Action == action)
    }
    
    func testChangeFromCAction() async throws {
        let actionBefore = action
        
        action = UserAction.fromCAction(Terminate)
        
        let actionAfter = action
        
        XCTAssertEqual(UserAction.terminate, actionAfter)
        XCTAssertNotEqual(actionBefore, actionAfter)
        XCTAssertTrue(action == Terminate)
    }
    
    func testConvertToCAction() async throws {
        action = .moveLeft
        
        let cAction = action.toCAction()
        
        XCTAssertTrue(action == cAction)
    }
    
}
