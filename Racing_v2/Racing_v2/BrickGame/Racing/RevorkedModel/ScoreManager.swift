//
//  ScoreManager.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 04.11.2024.
//

import Foundation

protocol Scorable {
    func addPoints()
    func resetScore()
}

protocol RacingScoreManager {
    var racingModel: RacingModel { get set }
    init(racingModel: RacingModel)
}

class ScoreManager: Scorable, RacingScoreManager {
    var racingModel: RacingModel
    
    required init(racingModel: RacingModel) {
        self.racingModel = racingModel
    }
    
    func addPoints() {
        for (pos, enemy) in racingModel.enemys.enumerated() {
            if enemy.yPos >= RacingDefines.yBorderSize {
                let points = addPoints(enemyType: type(of: racingModel.enemys[pos]))
                racingModel.enemys.remove(at: pos)
                racingModel.score += Int32(points)
//                if model.gameInfo.level < RacingDefines.maxLevel {
//                    levelUp()
//                }
            }
        }
    }
    
    func addPoints(enemyType: EnemyRacingCar.Type) -> RacingInt {
        
        guard let enemyType = enemyType as? HasScorePrice else {
            return CarPrice.defaultPrice
        }
        
        return enemyType.getPrice()
    }
    
    func resetScore() {
        racingModel.score = 0
    }
}
