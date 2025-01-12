//
//  ScoreIncreaseTests.swift
//  Racing
//
//  Created by Chingisbek Anvardinov on 14.12.2024.
//

import Testing
import XCTest
import Foundation

@testable import Race

class ScoreUnitTest: XCTestCase {
    let model = RacingModel()
    var scoreManager: ScoreManager!
    
    override func setUpWithError() throws {
        model.enemys = [EnemyCar(xPos: 0, yPos: 18)]
        self.scoreManager = ScoreManager(racingModel: model)
    }

    func testIsGameCars() async throws {
        XCTAssertTrue(model.enemys.first! is GameCar)
    }
    
    func testScoreNotIncrease() async throws {
        let scoreBeforeUpdate = model.score
        
        scoreManager.addPoints()
        
        let scoreAfterUpdate = model.score
        XCTAssertEqual(scoreBeforeUpdate, 0)
        XCTAssertEqual(scoreBeforeUpdate, scoreAfterUpdate)
    }
    
    func testScoreIncrease_0() async throws {
        model.enemys[0].yPos = 21
        let scoreBeforeUpdate = model.score
        
        scoreManager.addPoints()
        
        let scoreAfterUpdate = model.score
        XCTAssertNotEqual(scoreBeforeUpdate, scoreAfterUpdate)
        XCTAssertEqual(Int(scoreBeforeUpdate) + Int(CarPrice.defaultPrice), Int(scoreAfterUpdate))
    }
    
    func testScoreIncrease_1() async throws {
        model.enemys = [EnemyCar(xPos: 0, yPos: 21), EnemyCar(xPos: 7, yPos: 21)]
        let scoreBeforeUpdate = model.score
        
        scoreManager.addPoints()
        
        let scoreAfterUpdate = model.score
        XCTAssertNotEqual(scoreBeforeUpdate, scoreAfterUpdate)
        XCTAssertEqual(Int(scoreBeforeUpdate) + 2 * Int(CarPrice.defaultPrice), Int(scoreAfterUpdate))
    }
    
    func testScoreIncrease_2() async throws {
        model.enemys = [BlockEnemy(xPos: 0, yPos: 21)]
        let scoreBeforeUpdate = model.score
        
        scoreManager.addPoints()
        
        let scoreAfterUpdate = model.score
        XCTAssertNotEqual(scoreBeforeUpdate, scoreAfterUpdate)
        XCTAssertEqual(Int(scoreBeforeUpdate) + Int(CarPrice.blockEnemyPrice), Int(scoreAfterUpdate))
    }
    
    func testScoreIncrease_3() async throws {
        model.enemys = [DotEnemy(xPos: 0, yPos: 21)]
        let scoreBeforeUpdate = model.score
        
        scoreManager.addPoints()
        
        let scoreAfterUpdate = model.score
        XCTAssertNotEqual(scoreBeforeUpdate, scoreAfterUpdate)
        XCTAssertEqual(Int(scoreBeforeUpdate) + Int(CarPrice.dotEnemyPrice), Int(scoreAfterUpdate))
    }
    
    func testScoreIncrease_4() async throws {
        model.enemys = [DoorEnemy(xPos: 0, yPos: 21)]
        let scoreBeforeUpdate = model.score
        
        scoreManager.addPoints()
        
        let scoreAfterUpdate = model.score
        XCTAssertNotEqual(scoreBeforeUpdate, scoreAfterUpdate)
        XCTAssertEqual(Int(scoreBeforeUpdate) + Int(CarPrice.doorWallPrice), Int(scoreAfterUpdate))
    }
    
    func testNewEnemyScoreIncrease() async throws {
        model.enemys = [TestEnemy(xPos: 0, yPos: 21)]
        let scoreBeforeUpdate = model.score
        
        scoreManager.addPoints()
        
        let scoreAfterUpdate = model.score
        XCTAssertNotEqual(scoreBeforeUpdate, scoreAfterUpdate)
        XCTAssertEqual(Int(scoreBeforeUpdate) + Int(CarPrice.defaultPrice), Int(scoreAfterUpdate))
    }
}


class TestEnemy: GameCar, EnemyRacingCar {
    required init(xPos: RacingInt, yPos: RacingInt = -1) {
        super.init(xPos: xPos, yPos: yPos, car: [[0]])
    }
}
