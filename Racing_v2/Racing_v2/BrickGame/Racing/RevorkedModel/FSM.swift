//
//  FSM.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 03.11.2024.
//

import Foundation

enum BrickGameGameState {
    case start
    case pause
    case spawn
    case moving
    case collision
    case end
}

protocol FinalStateMachine {
    func loop(_ input: UserAction?)
    func start()
    func end()
}

class BrickGameStateMachine : FinalStateMachine {
    private var _currentState: BrickGameGameState = .pause
    var currentState: BrickGameGameState { get { _currentState } }
    static var lastInput: UserAction?

    deinit {
        print("🛑 GameStateMachine deinit ")
    }
    
    /// - Note: Swich state: *start -> spawn -> moving -> collision -> spawn*
    func loop(_ input: UserAction?) {
        switch _currentState {
        case .start:
            _currentState = .spawn
            start()
        case .pause:
            pause()
            
        case .spawn:
            BrickGameStateMachine.lastInput = input != nil ? input : nil
            _currentState = .moving
            spawn()
            
        case .moving:
            BrickGameStateMachine.lastInput = input != nil ? input : nil
            _currentState = .collision
            moving(with: input)
            
        case .collision:
            BrickGameStateMachine.lastInput = nil
            _currentState = .spawn
            collision()
            
        case .end:
            end()
            break
        }
//        return gameModel.updateGameInfo()
    }

    func setState(_ newState: BrickGameGameState) {
        _currentState = newState
    }

    func start() { }
    
    func pause() { }

    func spawn() { }
    
    func moving(with input: UserAction?) { }

    func collision() { }

    func end() { }
    
//    private func isSameModel(newModel: RacingModel?) -> Bool {
//        if let newModel = newModel, let racingModel = self.gameModel as? RacingModel, racingModel == newModel {
//            return true
//        }
//        return false
//    }
//
///          case .end:
///            racingModelInteraction { model in
///                model.gameInfoWrapper.gameState = .gameEnd
///            }
//    private func racingModelInteraction(_ interaction: (RacingModel) -> ()) {
//        if let model = gameModel as? RacingModel {
//            interaction(model)
//        }
//    }
}   // class BrickGameStateMachine

class RacingStateMachine: BrickGameStateMachine {
    var scoreManager: ScoreManager
    var spawner: BaseEnemySpawner
    var lvlManager: LevelManager
    var colisionHandler: CollisionHandler
    var racingModel: RacingModel
    var mover: BasicMover
    
    init(scoreManager: ScoreManager,
         spawner: BaseEnemySpawner,
         lvlManager: LevelManager,
         colisionHandler: CollisionHandler,
         mover: BasicMover,
         racingModel: RacingModel) {
        self.racingModel = racingModel
        self.scoreManager = scoreManager
        self.lvlManager = lvlManager
        self.colisionHandler = colisionHandler
        self.spawner = spawner
        self.mover = mover
    }
    
    override func start() {
        racingModel.restart()
    }
    
    override func pause() {
        if currentState == .pause {
            setState(.collision)
        } else {
            setState(.pause)
        }
    }

    override func spawn() {
        spawner.spawn()
    }
    
    override func moving(with input: UserAction?) {
        switch input {
        case .moveLeft, .moveRight:
            if let player = mover.move(with: input!) as? PlayerCar {
                racingModel.player = player
            }
        default:
            for var enemy in racingModel.enemys {
                enemy.yPos += 1
            }
            scoreManager.addPoints()
            lvlManager.levelUp()
        }
    }

    override func collision() {
        if colisionHandler.check() && racingModel.lives == 0 {
            setState(.end)
            end()
        }
    }

    override func end() {
        print("Save score and update higscore")
    }
}


