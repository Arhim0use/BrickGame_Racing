//
//  LevelManager.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 23.10.2024.
//

import Foundation

protocol LevelManager {
    var gameModel: GameModel { get set }
    func levelUp()
    func restart()
}

class LevelHandler: LevelManager {
    var gameModel: GameModel
    
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
            RacingInt(gameModel.score) % RacingDefines.toNextLvl == 0 {
            let lvl = gameModel.score / Int32(RacingDefines.toNextLvl)
            if lvl > 1 && lvl <= RacingDefines.maxLevel {
                if lvl != model.level {
                    model.gameInfoWrapper.gameInfo.speed += -9
                }
                model.gameInfoWrapper.gameInfo.level = lvl
            }
        }
    }
    
    func restart() {
        if let model = gameModel as? RacingModel {
            model.gameInfoWrapper.gameInfo.level = 1
            model.gameInfoWrapper.gameInfo.speed = RacingDefines.startSpeed
        }
    }
}   //  class LevelManager

class LVLHandler: LevelHandler {
    override func changeLVL() {
        guard let model = gameModel as? RacingModel else {
            return
        }
        
        let lvl = RacingInt(gameModel.score) / RacingDefines.toNextLvl
        if lvl < RacingDefines.speedArr.count - 1, lvl + 1 != model.level {
            model.gameInfoWrapper.gameInfo.speed = RacingDefines.speedArr[lvl]
            model.gameInfoWrapper.gameInfo.level = Int32(lvl + 1)
        }
    }
}
