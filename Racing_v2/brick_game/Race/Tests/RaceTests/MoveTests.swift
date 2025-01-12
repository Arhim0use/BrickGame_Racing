//
//  MoveTests.swift
//  Racing
//
//  Created by Chingisbek Anvardinov on 13.12.2024.
//

import Testing
import XCTest

@testable import Race


class ClassicMoveStrategyUnitTest: XCTestCase {
    var strategy = ClassicMoveStrategy()

    func testMoveForvatd() throws {
        let res = strategy.moveForvard()
        let expect = (0, 0)

        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }

    func testMoveBackvard() throws {
        let res = strategy.moveBackvard()
        let expect = (0, 0)

        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }

    func testMoveRight() throws {
        let res = strategy.moveRight()
        let expect = (3, 0)

        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }

    func testMoveLeft() throws {
        let res = strategy.moveLeft()
        let expect = (-3, 0)

        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }
}

class OneAxisMoveStrategyUnitTest: XCTestCase {
    var strategy = OneAxisMoveStrategy()
    
    func testMoveForvatd() throws {
        let res = strategy.moveForvard()
        let expect = (0, 0)
        
        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }
    
    func testMoveBackvard() throws {
        let res = strategy.moveBackvard()
        let expect = (0, 0)
        
        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }
    
    func testMoveRight() throws {
        let res = strategy.moveRight()
        let expect = (1, 0)
        
        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }
    
    func testMoveLeft() throws {
        let res = strategy.moveLeft()
        let expect = (-1, 0)
        
        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }
}

class BasicMoveStrategyUnitTest: XCTestCase {
    var strategy = BasicMoveStrategyFabric()
    
    func testMoveForvatd() throws {
        let res = strategy.moveForvard()
        let expect = (0, -1)
        
        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }
    
    func testMoveBackvard() throws {
        let res = strategy.moveBackvard()
        let expect = (0, 1)
        
        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }
}

class BasicMoverUnitTest: XCTestCase {
    let strategy = BasicMoveStrategyFabric()
    var object = PlayerCar()
    
    func testBeforeMove() throws {
        XCTAssertEqual(4, object.xPos)
        XCTAssertEqual(15, object.yPos)
    }
    
    func testMoveForvatd() throws {
        let mover = BasicMover(object: object, strategy: strategy)
        let res = mover.move(with: .moveUp)
        let expect = (4, 14)
        
        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }
    
    func testMoveBackvard() throws {
        let mover = BasicMover(object: object, strategy: strategy)
        let res = mover.move(with: .moveDown)
        let expect = (4, 16)
        
        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }
    
    func testMoveLeft() throws {
        let mover = BasicMover(object: object, strategy: strategy)
        let res = mover.move(with: .moveLeft)
        let expect = (3, 15)
        
        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }
    
    func testMoveRight() throws {
        let mover = BasicMover(object: object, strategy: strategy)
        
        let res = mover.move(with: .moveRight)
        let expect = (5, 15)
        
        XCTAssertEqual(expect.0, res.xPos)
        XCTAssertEqual(expect.1, res.yPos)
    }
}

class EnemyMoveUnitTest: XCTestCase {
    let model = RacingModel()
    var enemyMover: EnemyMover?
    
    override func setUpWithError() throws {
        model.enemys = [EnemyCar(xPos: 0, yPos: 0)]
        self.enemyMover = EnemyMover(model: model)
    }

    func testEnemyMove() async throws {
        let enemyPosAtStart = model.enemys.first!.yPos
        
        enemyMover!.startEnemyMovement()
        try await Task.sleep(nanoseconds: UInt64(0.4 * Double(NSEC_PER_SEC)))
        
        enemyMover!.stopEnemyMovement()
        let enemyPosAtStop = model.enemys.first!.yPos
        
        XCTAssertNotEqual(enemyPosAtStart, enemyPosAtStop)
    }
    
    func testEnemyPause() async throws {
        enemyMover!.startEnemyMovement()
        try await Task.sleep(nanoseconds: UInt64(0.2 * Double(NSEC_PER_SEC)))

        enemyMover!.pauseEnemyMovement(with: .pause)
        let enemyPosAfterPause = model.enemys.first!.yPos

        enemyMover!.stopEnemyMovement()
        let enemyPosAtStop = model.enemys.first!.yPos

        XCTAssertEqual(enemyPosAfterPause, enemyPosAtStop)
    }
    
    func testEnemyUnPause() async throws {
        enemyMover!.startEnemyMovement()
        try await Task.sleep(nanoseconds: UInt64(0.2 * Double(NSEC_PER_SEC)))

        enemyMover!.pauseEnemyMovement(with: .pause)
        let enemyPosAfterPause = model.enemys.first!.yPos
        
        enemyMover!.pauseEnemyMovement(with: .moving)
        try await Task.sleep(nanoseconds: UInt64(0.2 * Double(NSEC_PER_SEC)))

        enemyMover!.stopEnemyMovement()
        let enemyPosAtStop = model.enemys.first!.yPos

        XCTAssertNotEqual(enemyPosAfterPause, enemyPosAtStop)
    }
    
    func testSpeedUp() {
        let defoultSpeed = model.speed
        
        let nitro = enemyMover!.speedUp(.moveUp)
        
        XCTAssertNotEqual(defoultSpeed, nitro)
    }
    
    func testReturnToDefoultSpeed() {
        let defoultSpeed = model.speed
        
        _ = enemyMover!.speedUp(.moveUp)
        
        let returnedSpeed = enemyMover!.speedUp(.moveLeft)
        
        XCTAssertEqual(defoultSpeed, returnedSpeed)
    }
}
