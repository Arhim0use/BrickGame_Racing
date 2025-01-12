//
//  FSM.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 05.10.2024.
//

import Foundation

import CommonBrickGame

public enum BrickGameGameState {
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

    private static var _lastInput: UserAction? = nil
    var lastInput: UserAction? { get { BrickGameStateMachine._lastInput } }

    /// - Note: Swich state: *start -> spawn -> moving -> collision -> spawn*
    func loop(_ input: UserAction?) {
        switch _currentState {
        case .start:
            _currentState = .spawn
            start()
        case .pause:
            pause()
            
        case .spawn:
            lastInputUpdate(with: input)
            _currentState = .moving
            spawn()
            
        case .moving:
            lastInputUpdate(with: input)
            _currentState = .collision
            moving(with: BrickGameStateMachine._lastInput)
            
        case .collision:
            BrickGameStateMachine._lastInput = nil
            _currentState = .spawn
            collision()
            
        case .end:
            end()
            break
        }
    }

    func setState(_ newState: BrickGameGameState) {
        _currentState = newState
    }
    
    private func lastInputUpdate(with input: UserAction?) {
        guard input != nil else {
            return
        }
        
        BrickGameStateMachine._lastInput = input
    }
    
    func start() { }
    
    func pause() { }

    func spawn() { }
    
    func moving(with input: UserAction?) { }

    func collision() { }

    func end() { }
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
        setState(.spawn)
        racingModel.gameInfoWrapper.gameState = .gameRun
    }
    
    override func pause() {
        setState(.pause)
        racingModel.gameInfoWrapper.gameState = .gamePause
    }
    
    func resume() {
        setState(.collision)
        racingModel.gameInfoWrapper.gameState = .gameRun
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
            break
        }
        scoreManager.addPoints()
        lvlManager.levelUp()
    }

    override func collision() {
        if colisionHandler.check() && racingModel.lives == 0 {
            end()
        }
    }

    override func end() {
        racingModel.restart()
        
        racingModel.gameInfoWrapper.gameState = .gameEnd
        setState(.end)
    }
}    // class RacingStateMachine

