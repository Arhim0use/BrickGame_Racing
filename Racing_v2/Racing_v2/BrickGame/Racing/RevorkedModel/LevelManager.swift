//
//  LevelManager.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 03.11.2024.
//

import Foundation

//protocol Scorable {
//    func addPoints(_ points: Int)
//    func addPoints()
//    func resetScore()
//}
//
//class ScoreManager {
//    
//}
//
//protocol LevelManager {
//    var gameModel: GameModel? { get set }
//    func levelUp()
//}
//
//class LevelHandler: LevelManager {
//    weak var gameModel: GameModel?
//    
//    deinit {
//        print("🛑 levelmanager deinit ")
//    }
//    
//    /// - Note: use this to update lvl and add score points
//    func addPoints(_ points: RacingInt) {
//        guard let model = gameModel, let model = model as? RacingModel else {
//            return
//        }
//        
//        for (pos, enemy) in model.enemys.enumerated() {
//            if enemy.yPos >= RacingDefines.yBorderSize {
//                model.enemys.remove(at: pos)
//                model.score += Int32(points)
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
//    /// - Note: add lvl if gameInfo.score % RacingDefines.toNextLvl
//    func levelUp() {
//        guard let model = gameModel else {
//            return
//        }
//        
//        if RacingInt(model.gameInfo.score) % RacingDefines.toNextLvl == 0 {
////            model.gameInfoWrapper.gameInfo.level +=  1
//        }
//    }
//}   //  class LevelManager
