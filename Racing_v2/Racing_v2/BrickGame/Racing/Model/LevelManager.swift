//
//  ScoreCounter.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 23.10.2024.
//

import Foundation

protocol Scorable {
    var racingModel: RacingModel? { get set }
    
    func addPoints(_ points: Int)
    func addPoints()
    func levelUp()
    func resetScore()
}

class LevelManager: Scorable {
    weak var racingModel: RacingModel?
    
    deinit {
        print("🛑 levelmanager deinit ")
    }
    
    /// - Note: use this to update lvl and add score points
    func addPoints(_ points: RacingInt) {
        guard let model = racingModel else {
            return
        }
        
        for (pos, enemy) in model.enemys.enumerated() {
            if enemy.yPos >= RacingDefines.yBorderSize {
                model.enemys.remove(at: pos)
                model.gameInfoWr.gameInfo.score += Int32(points)
                if model.gameInfo.level < RacingDefines.maxLevel {
                    levelUp()
                }
            }
        }
    }
    
    /// - Note: use this to update lvl and add 1 score point
    func addPoints() {
        addPoints(1)
    }
    
    func resetScore() {
        racingModel?.gameInfoWr.gameInfo.score = 0
    }
    
    /// - Note: add lvl if gameInfo.score % RacingDefines.toNextLvl
    func levelUp() {
        guard let model = racingModel else {
            return
        }
        
        if RacingInt(model.gameInfo.score) % RacingDefines.toNextLvl == 0 {
            model.gameInfoWr.gameInfo.level +=  1
        }
    }
}   //  class LevelManager

class AdvancedLevelManager: LevelManager {
    
    let spawners: [EnemySpawner.Type] = [BasicEnemySpawner.self, LeftEnemySpawner.self, RightEnemySpawner.self, GeometricEnemySpawner.self]
    
    deinit {
            print("🛑 AdvancedLevelManager deinit ")
    }
    
    /// - Note: add lvl with manually defined logic
    override func levelUp() {
        guard let model = racingModel else {
            return
        }
        
        scoreHandler()
        
        if type(of: model.spawner) != spawnerSelect() {
            model.spawner = spawnerSelect().init()
            print("change spawn model ♦️")
        }
    }
    
    /// - Note: selects a spawner depending on the score
    func spawnerSelect() -> EnemySpawner.Type {
        guard let model = racingModel else {
            return BasicEnemySpawner.self
        }
        
        let level = model.gameInfo.level
        switch level {
        case 0:
            return spawners[2]
        case let x where x % 4 == 0:
            return spawners[1]
        case let x where x % 2 == 0:
            return spawners[3]
        default:
            return spawners[0]
        }
    }
    
    /// - Note: Account processing depending on the spawner
    func scoreHandler() {
        guard let model = racingModel, model.gameInfo.level <= RacingDefines.maxLevel else {
            return
        }
        
        let spawnType = type(of: model.spawner)
        
        switch spawnType {
        case is LeftEnemySpawner.Type:
            if model.gameInfo.score % 15 == 0 {
                model.gameInfoWr.gameInfo.level += 1
            }
        case is RightEnemySpawner.Type:
            if model.gameInfo.score % 15 == 0 {
                model.gameInfoWr.gameInfo.level +=  1
            }
        default:
            if RacingInt(model.gameInfo.score) % RacingDefines.toNextLvl == 0 {
                model.gameInfoWr.gameInfo.level +=  1
            }
        }
        
    }
}
