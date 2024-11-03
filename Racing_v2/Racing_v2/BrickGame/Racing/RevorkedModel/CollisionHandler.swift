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

class ____CollisionHandler: CollisionCars {

    var racingModel: RacingModel
    
    required init(racingModel: RacingModel) {
        self.racingModel = racingModel
    }
    
    deinit {
        print("🛑 CollisionHandler deinit ")
    }
    
    /// - Note: check all enemy car with player, also check player imortal state
    func check() -> Bool {

//        guard let model = racingModel else { return true }

        guard !racingModel.player.isImmortal else {
            racingModel.player.reduceImmortality()
            return false
        }
        
        for enemy in racingModel.enemys where racingModel.player.yPos <= enemy.yPos + enemy.car.ySize {
            if racingModel.player.xPos <= enemy.xPos + enemy.car.xSize
                && racingModel.player.xPos + racingModel.player.car.xSize > enemy.xPos {
                if isCollide(enemy) {
                    racingModel.player.isImmortal = true
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

        for y1 in 0..<firstCar.car.ySize {
            for x1 in 0..<firstCar.car.xSize {

                let y2 = y1 - yOffset
                let x2 = x1 - xOffset
                
                if y2 >= 0 && y2 < secondCar.car.ySize && x2 >= 0 && x2 < secondCar.car.xSize {
                    let firstValue = firstCar.car.car[y1][x1]
                    let secondValue = secondCar.car.car[y2][x2]
                    
                    if firstValue > 0 && secondValue > 0 {
                        return true
                    }
                }
            }
        }

        return false
    }

}   // class DefoultCollisionDetector