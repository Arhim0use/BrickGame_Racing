//
//  CollisionHandler.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 03.11.2024.
//

import Foundation

protocol CollisionCheckable {
    func check() -> Bool
}

protocol CollisionCars: CollisionCheckable {
    var racingModel: RacingModel { get set }
    init (racingModel: RacingModel)
}

class CollisionHandler: CollisionCars {

    var racingModel: RacingModel
    
    required init(racingModel: RacingModel) {
        self.racingModel = racingModel
    }
    
    deinit {
        print("🛑 CollisionHandler deinit ")
    }
    
    /// - Note: check all enemy car with player, also check player imortal state
    func check() -> Bool {

        guard !racingModel.player.isImmortal else {
            racingModel.player.reduceImmortality()
            return false
        }
        
        for enemy in racingModel.enemys where racingModel.player.yPos <= enemy.yPos + enemy.ySize {
            if racingModel.player.xPos <= enemy.xPos + enemy.xSize
                && racingModel.player.xPos + racingModel.player.xSize > enemy.xPos {
                if isCollide(enemy) {
                    racingModel.player.isImmortal = true
                    racingModel.lives -= 1
                    return true
                }
            }
        }
        return false
    }
    
    /// - Note: check one enemy car with player's car
    private func isCollide(_ enemy: any RacingCar) -> Bool {
        
        let firstCar = racingModel.player.xPos < enemy.xPos ? racingModel.player : enemy
        let secondCar = racingModel.player.car == firstCar.car ? enemy : racingModel.player

        let xOffset = secondCar.xPos - firstCar.xPos
        let yOffset = secondCar.yPos - firstCar.yPos

        for y1 in 0..<firstCar.ySize {
            for x1 in 0..<firstCar.xSize {

                let y2 = y1 - yOffset
                let x2 = x1 - xOffset
                
                if y2 >= 0 && y2 < secondCar.ySize && x2 >= 0 && x2 < secondCar.xSize {
                    let firstValue = firstCar.car[y1][x1]
                    let secondValue = secondCar.car[y2][x2]
                    
                    if firstValue > 0 && secondValue > 0 {
                        return true
                    }
                }
            }
        }

        return false
    }

}   // class DefoultCollisionDetector
