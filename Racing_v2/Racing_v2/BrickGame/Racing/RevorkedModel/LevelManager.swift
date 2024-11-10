//
//  LevelManager.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 03.11.2024.
//

import Foundation

protocol LevelManager {
    var gameModel: GameModel { get set }
    func levelUp()
    func restart()
}

class LevelHandler: LevelManager {
    var gameModel: GameModel
    
    deinit {
        print("🛑 Level manager deinit ")
    }
    
    required init(gameModel: GameModel) {
        self.gameModel = gameModel
    }
    
    /// - Note: add lvl and speed up in gameInfo
    func levelUp() {
        guard gameModel.level <= RacingDefines.maxLevel else {
            return
        }
        
        changeLVL()
    }
    
    func changeLVL() {
        if let model = gameModel as? RacingModel,
            RacingInt(gameModel.score) % RacingDefines.toNextLvl == 0 &&
            gameModel.level < RacingDefines.maxLevel
        {
            let lvl = gameModel.score / Int32(RacingDefines.toNextLvl)
            model.gameInfoWrapper.gameInfo.level = lvl
            model.gameInfoWrapper.gameInfo.speed += -7
        }
    }
    
    func restart() {
        if let model = gameModel as? RacingModel {
            model.gameInfoWrapper.gameInfo.level = 1
            model.gameInfoWrapper.gameInfo.speed = 100
        }
    }
}   //  class LevelManager
