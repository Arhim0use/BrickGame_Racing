//
//  SpawnTests.swift
//  Racing
//
//  Created by Chingisbek Anvardinov on 13.12.2024.
//

import Testing
import XCTest
import Foundation

@testable import Race

class SpawnUnitTest: XCTestCase {
    private let defoultDoubleCarChance: UInt8 = 10
    private let defoultOffcet = 3
    private let defoultMaxEnemyCount = 5
    let model = RacingModel()
    var spawner: ClassicEnemySpawner!
    
    override func setUpWithError() throws {
        model.enemys = [EnemyCar(xPos: 0, yPos: 0)]
        self.spawner = ClassicEnemySpawner(racingModel: model)
    }

    func testIsGameCars() throws {
        XCTAssertTrue(model.enemys.first! is GameCar)
    }
    
    func testCantSpawn_0() throws {
        let enemysBeforeSpawn = model.enemys as? [GameCar]
        
        spawner.spawn()
        
        let enemysAfterSpawn = model.enemys as? [GameCar]
        
        XCTAssertEqual(enemysBeforeSpawn!.count, enemysAfterSpawn!.count)
        XCTAssertEqual(enemysBeforeSpawn!, enemysAfterSpawn!)
    }
    
    func testCantSpawn_1() throws {
        model.enemys[0].yPos = 4
        spawner.maxEnemyCount = 1
        
        let enemysBeforeSpawn = model.enemys as? [GameCar]
        
        for _ in 0...20 {
            spawner.spawn()
        }
        
        let enemysAfterSpawn = model.enemys as? [GameCar]
        
        spawner.maxEnemyCount = defoultMaxEnemyCount
        XCTAssertEqual(enemysBeforeSpawn!.count, enemysAfterSpawn!.count)
        XCTAssertEqual(enemysBeforeSpawn!, enemysAfterSpawn!)
    }
    
    func testCantSpawn_2() throws {
        model.enemys[0].yPos = 4
        spawner.minOffset = 5
        
        let enemysBeforeSpawn = model.enemys as? [GameCar]
        
        for _ in 0...20 {
            spawner.spawn()
        }
        
        let enemysAfterSpawn = model.enemys as? [GameCar]
        spawner.minOffset = defoultOffcet

        XCTAssertEqual(enemysBeforeSpawn!.count, enemysAfterSpawn!.count)
        XCTAssertEqual(enemysBeforeSpawn!, enemysAfterSpawn!)
    }
    
    func testAlwaysSpawn() throws {
        model.enemys.removeAll()
        let enemysBeforeSpawn = model.enemys as? [GameCar]
        
        spawner.spawn()
        
        let enemysAfterSpawn = model.enemys as? [GameCar]

        XCTAssertNotEqual(enemysBeforeSpawn!.count, enemysAfterSpawn!.count)
        XCTAssertNotEqual(enemysBeforeSpawn!, enemysAfterSpawn!)
    }
    
    func testSpawn_0() throws {
        model.enemys[0].yPos = 5
        spawner.doubleCarChanse = 0
        let enemysBeforeSpawn = model.enemys as? [GameCar]
        
        for _ in 0...25 {
            spawner.spawn()
        }
        
        let enemysAfterSpawn = model.enemys as? [GameCar]
        
        spawner.doubleCarChanse = defoultDoubleCarChance
        XCTAssertEqual(enemysBeforeSpawn!.count, 1)
        
        XCTAssertNotEqual(enemysBeforeSpawn!.count, enemysAfterSpawn!.count)
        XCTAssertNotEqual(enemysBeforeSpawn!, enemysAfterSpawn!)
    }
    
    func testSpawn_1() throws {
        model.enemys[0].yPos = 4
        spawner.minOffset = 0
        let enemysBeforeSpawn = model.enemys as? [GameCar]
        
        for _ in 0...5 {
            spawner.spawn()
        }
        
        let enemysAfterSpawn = model.enemys as? [GameCar]

        spawner.minOffset = defoultOffcet
        XCTAssertEqual(enemysBeforeSpawn!.count, 1)
        
        XCTAssertNotEqual(enemysBeforeSpawn!.count, enemysAfterSpawn!.count)
        XCTAssertNotEqual(enemysBeforeSpawn!, enemysAfterSpawn!)
    }
    
    func testSpawnDouble() throws {
        model.enemys.removeAll()
        spawner.doubleCarChanse = 100
        
        let enemysBeforeSpawn = model.enemys as? [GameCar]
        
        spawner.spawn()
        
        let enemysAfterSpawn = model.enemys as? [GameCar]

        spawner.doubleCarChanse = defoultDoubleCarChance
        XCTAssertEqual(enemysBeforeSpawn!.count, 0)
        
        XCTAssertEqual(enemysAfterSpawn!.count, 2)
    }
}

class RandomSideSpawnTest: XCTestCase {
    let model = RacingModel()
    var spawner: RandomSideSpawner!
    
    override func setUpWithError() throws {
        model.enemys = []
        self.spawner = RandomSideSpawner(racingModel: model)
    }

    func testIsGameCars() throws {
        spawner.spawn()
        
        if spawner.onLeft {
            XCTAssertTrue(model.enemys.first!.xPos <= 5)
        } else {
            XCTAssertTrue(model.enemys.first!.xPos >= 5)
        }
    }
}
