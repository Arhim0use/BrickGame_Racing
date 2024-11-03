//
//  LevelManager.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 03.11.2024.
//

import Foundation

//protocol Scorable {
//    var racingModel: RacingModel? { get set }
//    
//    func addPoints(_ points: Int)
//    func addPoints()
//    func levelUp()
//    func resetScore()
//}

//class LevelManager: PREV_Scorable {
//    weak var racingModel: PREV_RacingModel?
//    
//    deinit {
//        print("🛑 levelmanager deinit ")
//    }
//    
//    /// - Note: use this to update lvl and add score points
//    func addPoints(_ points: RacingInt) {
//        guard let model = racingModel else {
//            return
//        }
//        
//        for (pos, enemy) in model.enemys.enumerated() {
//            if enemy.yPos >= RacingDefines.yBorderSize {
//                model.enemys.remove(at: pos)
//                model.gameInfoWr.gameInfo.score += Int32(points)
//                if model.gameInfo.level < RacingDefines.maxLevel {
//                    levelUp()
//                }
//            }
//        }
//    }
//    
//    /// - Note: use this to update lvl and add 1 score point
//    func addPoints() {
//        addPoints(1)
//    }
//    
//    func resetScore() {
//        racingModel?.gameInfoWr.gameInfo.score = 0
//    }
//    
//    /// - Note: add lvl if gameInfo.score % RacingDefines.toNextLvl
//    func levelUp() {
//        guard let model = racingModel else {
//            return
//        }
//        
//        if RacingInt(model.gameInfo.score) % RacingDefines.toNextLvl == 0 {
//            model.gameInfoWr.gameInfo.level +=  1
//        }
//    }
//}   //  class LevelManager
