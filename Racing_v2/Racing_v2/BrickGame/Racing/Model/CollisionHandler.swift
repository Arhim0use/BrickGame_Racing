//
//  CollisionHandler.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 20.10.2024.
//

import Foundation


protocol PREV_CollisionCheckable {
    var racingModel: RacingModel? { get set }
    func check() -> Bool
    func isCollide(_ enemy: any RacingCar) -> Bool
}

class CollisionHandler: PREV_CollisionCheckable {
    
    weak var racingModel: RacingModel? = nil
    
    deinit {
            print("🛑 CollisionHandler deinit ")
    }
    
    /// - Note: check one enemy car with player's car
    func isCollide(_ enemy: any RacingCar) -> Bool {
        
        guard let model = racingModel else { return true }
        
        let firstCar = model.player.xPos < enemy.xPos ? model.player : enemy
        let secondCar = model.player.car == firstCar.car ? enemy : model.player

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
    
    /// - Note: check all enemy car with player, also check player imortal state
    func check() -> Bool {

        guard let model = racingModel else { return true }

        guard !model.player.isImmortal else {
            model.player.reduceImmortality()
            return false
        }
        
        for enemy in model.enemys where model.player.yPos <= enemy.yPos + enemy.car.ySize {
            if model.player.xPos <= enemy.xPos + enemy.car.xSize
                && model.player.xPos + model.player.car.xSize > enemy.xPos {
                if isCollide(enemy) {
                    model.player.isImmortal = true
                    return true
                }
            }
        }
        return false
    }

}   // class DefoultCollisionDetector
