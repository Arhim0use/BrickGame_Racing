//
//  RacingModel.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 02.11.2024.
//

import Foundation

protocol GameModel: AnyObject {

    var gameInfo: GameInfo_t { get }
    var score: Int32 { get }
    var highScore: Int32  { get }
    var level: Int32  { get }
    var speed: Int32 { get }
    var pause: Int32  { get }
    
    func placeObjectOnField() -> GameInfo_t
}

extension RacingModel: Equatable {
    static func == (lhs: RacingModel, rhs: RacingModel) -> Bool {
        lhs.id == rhs.id
    }
}

class RacingModel: GameModel, Identifiable {
    let id: ObjectIdentifier = ObjectIdentifier(RacingModel.self)
    var gameInfoWrapper = GameInfoWrapper()
    var player = PlayerCar()
    var enemys: [EnemyRacingCar] = []
    
    private var _playerLives = RacingDefines.startLiveCount
    
    deinit {
        print("🛑 RacingModel deinit ")
    }
    
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
    
    var lives: RacingInt {
        get { _playerLives }
        set {
            guard newValue >= 0 else {
                return
            }
            _playerLives = newValue
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
    var speed: Int32 {
        get { gameInfo.speed }
        set {
            if newValue > 1 {
                gameInfoWrapper.gameInfo.speed = newValue
            }
        }
    }
    
    func placeObjectOnField() -> GameInfo_t {
        guard gameInfoWrapper.matrixIsAllocate() else {
            return gameInfo
        }
        
        clearField()
        
        placeCarField(rCar: player)
        for enemy in enemys {
            placeCarField(rCar: enemy)
        }
        return gameInfo
    }
    
    func restart() {
        lives = RacingDefines.startLiveCount
        score = 0
        highScore = 0
        level = 1
        speed = RacingDefines.startSpeed
        pause = 0
        enemys.removeAll()
        player = PlayerCar()
        gameInfoWrapper.gameInfo = placeObjectOnField()
    }
    
    private func placeCarField(rCar: RacingCar) {
        for carRow in 0..<rCar.ySize {
            let fieldY = rCar.yPos + carRow

            if fieldY < 0 {
                continue
            }
            
            if fieldY >= RacingDefines.yBorderSize {
                break
            }
            
            for carCell in 0..<rCar.xSize {
                let fieldX = rCar.xPos + carCell
                if fieldX >= RacingDefines.xBorderSize {
                    continue
                }

                if gameInfoWrapper.gameInfo.field[fieldY]![fieldX] == 0 {
                    gameInfoWrapper.gameInfo.field[fieldY]![fieldX] = Int32(rCar.car[carRow][carCell])
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
