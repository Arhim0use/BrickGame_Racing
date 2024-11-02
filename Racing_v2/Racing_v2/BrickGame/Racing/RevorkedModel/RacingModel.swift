//
//  RacingModel.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 02.11.2024.
//

import Foundation

protocol NewGameModel {
    var gameInfoWrapper: GameInfoWrapper { get set }
    var gameInfo: GameInfo_t { get }
    var score: Int32 { get }
    var highScore: Int32  { get }
    var level: Int32  { get }
    var speed: Int32 { get }
    var pause: Int32  { get }
    
    func placeObjectOnField()
}

struct RacingModel: NewGameModel {
    
    var gameInfoWrapper = GameInfoWrapper()
    var player = PlayerCar()
    var enemys: [EnemyRacingCar] = []
    
    var gameInfo: GameInfo_t { get { gameInfoWrapper.gameInfo } }
    
    var score: Int32 {
        get {
            gameInfo.score
        }
        set {
            gameInfoWrapper.gameInfo.score = newValue
        }
    }
    
    var highScore: Int32 {
        get {
            gameInfo.high_score
        }
        set {
            gameInfoWrapper.gameInfo.high_score = newValue
        }
    }
    
    var level: Int32 {
        get {
            gameInfo.level
        }
        set {
            gameInfoWrapper.gameInfo.level = newValue
        }
    }
    
    var pause: Int32 {
        get {
            Int32(gameInfoWrapper.gameState.rawValue)
        }
        set {
            gameInfoWrapper.gameState = GameInfoWrapper.GameState(rawValue: RacingInt(newValue)) ?? .gameEnd
        }
    }
    
    /// - Note: сделать скорость вычесляемой
    var speed: Int32 { get { gameInfo.speed } }
    
    func placeObjectOnField() {
        guard gameInfoWrapper.matrixIsAllocate() else {
            return
        }
        
        clearField()
        
        placeCarField(rCar: player)
        for enemy in enemys {
            placeCarField(rCar: enemy)
        }
    }
    
    private func placeCarField(rCar: RacingCar) {
        for carRow in 0..<rCar.car.ySize {
            let fieldY = rCar.yPos + carRow

            if fieldY < 0 {
                continue
            }
            
            if fieldY >= RacingDefines.yBorderSize {
                break
            }
            
            for carCell in 0..<rCar.car.xSize {
                let fieldX = rCar.xPos + carCell
                if fieldX >= RacingDefines.xBorderSize {
                    continue
                }

                if gameInfoWrapper.gameInfo.field[fieldY]![fieldX] == 0 {
                    gameInfoWrapper.gameInfo.field[fieldY]![fieldX] = Int32(rCar.car.car[carRow][carCell])
                }
            }
        }
    }
    
    private func clearField() {
        for y in 0..<RacingDefines.yBorderSize {
            for x in 0..<RacingDefines.xBorderSize {
                gameInfoWrapper.gameInfo.field[y]![x] = 0
            }
        }
    }
    
}   // RacingModel
