//
//  FSA.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 05.10.2024.
//

import Foundation

//import cFiles

enum BrickGameGameState {
    case start
    case pause
    case spawn
    case moving
    case collision
    case end
}

protocol PREV_FinalStateMachine {
    var gameModel: PREV_GameModel? { get set }
    
    var currentState: BrickGameGameState { get }
    func gameLoop(_ playerInput: UserAction?) -> GameInfo_t
    func start()
}

class PREV_RacingStateMachine : PREV_FinalStateMachine {
    private var _currentState: BrickGameGameState = .pause
    var currentState: BrickGameGameState { get { _currentState } }
    weak var gameModel: PREV_GameModel? = nil
    
    init(gameModel: PREV_GameModel) {
        self.gameModel = gameModel
    }
    
    init() {
        self.gameModel = nil
    }
    
    deinit {
        print("🛑 GameStateMachine deinit ")
    }
    
    func start() {
            _currentState = .start
    }
    
    func gameLoop(_ playerInput: UserAction?) -> GameInfo_t {
        guard let gameModel = self.gameModel else {
            return GameInfo_t()
        }
        
        switch _currentState {
        case .start:
            startGame()
        case .pause:
            racingModelInteraction { model in
                model.gameInfoWr.gameState = .gamePause
            }
        case .spawn:
            spawn()
        case .moving:
            updateBoard(playerInput)
        case .collision:
            collision()
        case .end:
            racingModelInteraction { model in
                model.gameInfoWr.gameState = .gameEnd
            }

            break
        }
        
        racingModelInteraction { model in
            print("enemys.count", model.enemys.count)
            print("livesCount", model.livesCount)
            print("score", model.gameInfo.score)
            print("spawner", model.spawner)
            print("level manager", model.levelManager)
            model.gameInfoWr.printField()
        }

        return gameModel.updateGameInfo()
        
    }
    
    func setState(_ newState: BrickGameGameState) {
        _currentState = newState
    }
    
    private func startGame() {
        guard let gameModel = self.gameModel else {
            return
        }
        
        defer {
            _currentState = .spawn
        }
        
        if let model = gameModel as? PREV_RacingModel {
            model.gameInfoWr.gameState = .gameRun
            model.restartGame()
        }
        
    }
    
    private func spawn() {
        guard let gameModel = self.gameModel else {
            return
        }
        
        defer {
            _currentState = .moving
        }
        
        racingModelInteraction { model in
            model.gameInfoWr.gameState = .gameRun
        }
        
        gameModel.spawnNext()
    }

    private func updateBoard(_ playerInput: UserAction?) {
        guard let gameModel = self.gameModel else {
            return
        }
        
        defer {
            _currentState = .collision
            gameModel.updateScore()
        }
        
        guard let inp = playerInput else {
            gameModel.updateBoard()
            return
        }
        
        playerAction(inp)
    }
    
    private func playerAction(_ playerInput: UserAction) {
        guard let gameModel = self.gameModel else {
            return
        }
        
        guard playerInput == .moveLeft || playerInput == .moveRight else {
            return
        }
        
        let value = playerInput == .moveLeft ? -1 : 1
        
        gameModel.playerAction(action: playerInput.toCAction(), value: value)
    }
    
    private func collision() {
        guard let gameModel = self.gameModel else {
            return
        }
        
        _currentState = .spawn

        if gameModel.gameIsOver() {

            racingModelInteraction { gameModel in
                if gameModel.livesCount == 0 {
                    _currentState = .end
                    gameModel.gameInfoWr.gameState = .gameEnd
                }
            }
        }
    }

    private func racingModelInteraction(_ interaction: (PREV_RacingModel) -> ()) {
        guard let gameModel = self.gameModel else {
            return
        }
        
        if let model = gameModel as? PREV_RacingModel {
            interaction(model)
        }
    }
}   // class RacingStateMachine



