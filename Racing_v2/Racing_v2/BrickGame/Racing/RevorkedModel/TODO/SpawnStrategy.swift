//
//  SpawnStrategy.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 06.11.2024.
//

import Foundation

protocol Spawnable {
    func spawnNext(at position: (xPos: RacingInt, yPos: RacingInt)) -> GameObject
}

protocol SpawnStrategy {
    func getPosition() -> (xPos: RacingInt, yPos: RacingInt)
}

class RandomPosirionStrategy: SpawnStrategy {
    func getPosition() -> (xPos: RacingInt, yPos: RacingInt) {
        return (RacingInt.random(in: 0..<RacingDefines.xBorderSize), -6)
    }
}

class BaseSpawner {
    var spawnOffset: UInt8
    var spawnRate: RacingInt
    var objects: [GameObject]
    
    init(objects: [GameObject], spawnRate: RacingInt, spawnOffset: UInt8) {
        self.objects = objects
        self.spawnRate = spawnRate
        self.spawnOffset = spawnOffset
    }
    
    func spawn() { objects.append(EnemyGameCar.init(xPos: 0)) }
}

class EnemySpawnerFabric: BaseSpawner {
    var enemyType: EnemyRacingCar.Type
    
    init(objects: [GameObject], spawnRate: RacingInt, spawnOffset: UInt8, enemyType: EnemyRacingCar.Type) {
        self.enemyType = enemyType
        super.init(objects: objects, spawnRate: spawnRate, spawnOffset: spawnOffset)
    }
}

class EnemySpawner: EnemySpawnerFabric, Spawnable {
    func spawnNext(at position: (xPos: RacingInt, yPos: RacingInt)) -> any GameObject {
        return enemyType.init(xPos: position.xPos, yPos: position.yPos)
    }
}



class BonusSpawnerFabric: BaseSpawner {
    var bonusType: BonusObject.Type
    
    init(objects: [GameObject], spawnRate: RacingInt, spawnOffset: UInt8, bonusType: BonusObject.Type) {
        self.bonusType = bonusType
        super.init(objects: objects, spawnRate: spawnRate, spawnOffset: spawnOffset)
    }
}

class BonusSpawner: BonusSpawnerFabric, Spawnable {
    func spawnNext(at position: (xPos: RacingInt, yPos: RacingInt)) -> any GameObject {
        return bonusType.init(xPos: position.xPos, yPos: position.yPos)
    }
}



