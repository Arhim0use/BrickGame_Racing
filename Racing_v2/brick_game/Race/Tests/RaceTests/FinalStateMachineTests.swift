//
//  FinalStateMachineTests.swift
//  Racing
//
//  Created by Chingisbek Anvardinov on 15.12.2024.
//

import Testing
import XCTest
import Foundation

@testable import Race


class RSMUnitTest: XCTestCase {
    var model: RacingModel!
    var fsm: RacingStateMachine!
    
    override func setUpWithError() throws {
        model = RacingModel()
        fsm = RacingStateMachine(scoreManager: TestScoreManager(racingModel: model),
                                        spawner: TestEnemySpawner(racingModel: model),
                                        lvlManager: TestLevelHandler(gameModel: model),
                                        colisionHandler: TestCollider(racingModel: model),
                                 mover: TestMover(object: PlayerCar(xPos: 0, yPos: 0), strategy: ClassicMoveStrategy()),
                                        racingModel: model)
    }

    func testStart() async throws {
        model.score = 100
        model.level = 4
        let scoreBefore = model.score
        let levelBefore = model.level
        
        fsm.start()
        
        XCTAssertNotEqual(levelBefore, model.level)
        XCTAssertNotEqual(scoreBefore, model.score)
        
        XCTAssertEqual(fsm.currentState, BrickGameGameState.spawn)
        XCTAssertEqual(model.score, 0)
        XCTAssertEqual(model.level, 1)
    }
    
    func testPause() async throws {
        fsm.pause()
        
        XCTAssertEqual(fsm.currentState, BrickGameGameState.pause)
    }
    
    func testSpawn() async throws {
        model.enemys = []
        fsm.spawner.doubleCarChanse = 0
        
        fsm.spawn()
        
        XCTAssertEqual(model.enemys.count , 1)
    }
    
    func testCollisionAndGameEnd()async throws {
        model.lives = 0
        
        fsm.collision()
        
        XCTAssertEqual(fsm.currentState, BrickGameGameState.end)
    }
    
    func testEnd()async throws {

        fsm.end()
        
        XCTAssertEqual(fsm.currentState, BrickGameGameState.end)
    }
    
    func testMoving() async throws {
        XCTAssertEqual(model.score , 0)
        XCTAssertEqual(model.level , 1)

        fsm.moving(with: .moveDown)
        
        XCTAssertEqual(model.score , 1)
        XCTAssertEqual(model.level , 2)
    }
    
    func testMovingVertical() async throws {
        let yPosBefore = model.player.yPos

        fsm.moving(with: .moveDown)
        
        let yPosAfter =  model.player.yPos
        
        XCTAssertEqual(yPosBefore, yPosAfter)
    }
    
    func testMovingHorizontal() async throws {
        let xPosBefore = model.player.xPos

        fsm.moving(with: .moveLeft)
        
        let xPosAfter =  model.player.xPos
        
        XCTAssertNotEqual(xPosBefore, xPosAfter)
        XCTAssertEqual(xPosBefore, xPosAfter - 1)
    }
    
    func testLoop_0() {
        let inputBefore = fsm.lastInput
        
        fsm.setState(.spawn)
        fsm.loop(nil)
        
        let inputAfter = fsm.lastInput
        
        XCTAssertEqual(inputBefore, inputAfter)
    }
    
    func testLoop_1() {
        let inputBefore = fsm.lastInput
        
        fsm.setState(.spawn)
        fsm.loop(.moveLeft)
        
        let inputAfter = fsm.lastInput
        
        XCTAssertNotEqual(inputBefore, inputAfter)
        XCTAssertEqual(inputAfter, UserAction.moveLeft)
        fsm.loop(nil)
        fsm.loop(nil)
    }
    
    func testLoop_2() {
        let inputBefore = fsm.lastInput
        
        fsm.setState(.spawn)
        fsm.loop(.moveRight)
        fsm.loop(.moveLeft)

        let inputAfter = fsm.lastInput
        
        XCTAssertNotEqual(inputBefore, inputAfter)
        XCTAssertEqual(inputAfter, UserAction.moveLeft)
        XCTAssertEqual(fsm.currentState, BrickGameGameState.collision)
        fsm.loop(nil)
    }
    
    func testLoop_3() {
        let inputBefore = fsm.lastInput
        
        fsm.setState(.spawn)
        fsm.loop(.moveRight)
        fsm.loop(nil)

        let inputAfter = fsm.lastInput
        
        XCTAssertNotEqual(inputBefore, inputAfter)
        XCTAssertEqual(inputAfter, UserAction.moveRight)
        XCTAssertEqual(fsm.currentState, BrickGameGameState.collision)
    }
}


class TestMover: BasicMover {
    override func move(with input: UserAction) -> GameObject {
        return PlayerCar(xPos: 5, yPos: 10)
    }
    
    override func move(by position: (xPos: RacingInt, yPos: RacingInt)) {
        object.xPos += 1
        object.yPos += 1
    }
}


class TestCollider: CollisionHandler {
    override func check() -> Bool {
        return true
    }
}


class TestLevelHandler: LevelHandler {
    override func levelUp() {
        guard gameModel.level <= RacingDefines.maxLevel else {
            return
        }
        changeLVL()
    }
    
    override func changeLVL() {
        guard let model = gameModel as? RacingModel else { return }
        if RacingInt(gameModel.score) % 1 == 0 {
            model.gameInfoWrapper.gameInfo.level = gameModel.level + 1
        }
    }
    
    override func restart() {
        if let model = gameModel as? RacingModel {
            model.gameInfoWrapper.gameInfo.level = 1
        }
    }
}

class TestEnemySpawner: BaseEnemySpawner {
    override func spawnLogic() {
        racingModel.enemys = [EnemyCar(xPos: 5, yPos: 5)]
    }
}

class TestScoreManager: ScoreManager {
    override func addPoints() {
        racingModel.score += 1
    }
    
    /// - Note: calculate the price for enemy car
    override func addPoints(enemyType: EnemyRacingCar) -> RacingInt {
        return 2
    }
}
