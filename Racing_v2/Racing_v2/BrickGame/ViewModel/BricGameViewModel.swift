//
//  ViewModel.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 27.10.2024.
//

import Foundation

//import cFiles

import Combine

protocol BricGameViewModel {
    var currentState: BrickGameGameState { get }
    var score: RacingInt { get }
    var lives: RacingInt { get }
    var level: RacingInt { get }
    
//    var speed: RacingInt: { get }
//    var highscore: String { get }
    
    func startGame()
    func pauseGame()
    func updateGame(with action: UserAction?)
    func endGame()
}

class RacingViewModel: ObservableObject, BricGameViewModel {
    /*private*/ var _model: GameModel
    private var _gameInfo: GameInfoWrapper

    init() {
        self._gameInfo = GameInfoWrapper()
        self._model = PREV_RacingModel(gameInfoWrapper: self._gameInfo)
    }
    
    deinit {
        print("🛑 RacingViewModel deinit ")
    }
    
    var gameInfo: GameInfo_t {
        return _gameInfo.gameInfo
    }
    
    var currentState: BrickGameGameState {
        guard let model = _model as? PREV_RacingModel else {
            return .end
        }
        
        return model.racingFSM.currentState
    }

    var score: RacingInt {
        guard let model = self._model as? PREV_RacingModel else {
            return 0
        }
        
        return RacingInt(model.gameInfo.score)
    }

    var lives: RacingInt {
        guard let model = self._model as? PREV_RacingModel else {
            return 0
        }
        return RacingInt(model.livesCount)
    }

    var level: RacingInt {
        guard let model = self._model as? PREV_RacingModel else {
            return 0
        }
        return RacingInt(model.gameInfo.level)
    }

    func startGame() {
        guard let model = self._model as? PREV_RacingModel else {
            return
        }
        
        model.startGame()
    }

    func pauseGame() {
        guard let model = self._model as? PREV_RacingModel else {
            return
        }
        
        model.pauseGame()
    }

    func updateGame(with action: UserAction?) {
        guard let model = self._model as? PREV_RacingModel else {
            return
        }
        
        model.racingFSM.gameLoop(action)
    }

    func endGame() {
        // Сохранение счета, окончание игры
    }
}
