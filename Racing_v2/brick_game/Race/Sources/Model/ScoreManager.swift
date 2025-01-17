//
//  ScoreManager.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 08.11.2024.
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
            if enemy.yPos > RacingDefines.yBorderSize {
                let points = addPoints(enemyType: racingModel.enemys[pos])
                racingModel.score += Int32(points)
            }
        }
        racingModel.enemys.removeAll(where: { $0.yPos > RacingDefines.yBorderSize })
    }
    
    /// - Note: calculate the price for enemy car
    func addPoints(enemyType: EnemyRacingCar) -> RacingInt {
        
        guard let enemy = enemyType as? HasScorePrice else {
            return RacingInt(CarPrice.defaultPrice)
        }

        return RacingInt(enemy.getPrice())
    }
    
    func resetScore() {
        racingModel.score = 0
    }
}
