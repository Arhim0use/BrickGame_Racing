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
    var gameInfo: GameInfo_t { get }
    var score: RacingInt { get }
    var highscore: String { get }
    var lives: RacingInt { get }
    var level: RacingInt { get }
    var speed: RacingInt { get }
    
    func startGame()
    func pauseGame()
    func userInput(with action: UserAction_t)
    func endGame()
}

class RacingViewModel: ObservableObject, BricGameViewModel {
    
    private(set) var currentState: BrickGameGameState = .pause
    
    private(set) var model: RacingModel = RacingModel() {
        willSet {
            lvlManager.gameModel = newValue
            scoreManager.racingModel = newValue
            collisionHandler.racingModel = newValue
        }
    }
    
    private(set) var fsm: RacingStateMachine
    private(set) var spawner: BaseEnemySpawner {
        willSet {
            fsm.spawner = newValue
        }
    }
    private(set) var mover: BasicMover {
        willSet {
            fsm.mover = newValue
        }
    }
    private(set) var lvlManager: LevelHandler {
        willSet {
            fsm.lvlManager = newValue
        }
    }
    private(set) var scoreManager: ScoreManager {
        willSet {
            fsm.scoreManager = newValue
        }
    }
    private(set) var collisionHandler: CollisionHandler {
        willSet {
            fsm.colisionHandler = newValue
        }
    }

//    var higscoreManager: HigscoreManager
    
    var gameState: BrickGameGameState { get { fsm.currentState } }
    
    var lives: RacingInt { get { model.lives } }
    
    var level: RacingInt { get { RacingInt(gameInfo.level) } }
    
    var speed: RacingInt { get { RacingInt(model.speed) } }

    var score: RacingInt { get { RacingInt(gameInfo.score) } }

    var gameInfo: GameInfo_t { get { model.gameInfo } }

    var highscore: String = ""
    
    init() {
        lvlManager = LevelHandler(gameModel: self.model)
        scoreManager = ScoreManager(racingModel: self.model)
        collisionHandler = CollisionHandler(racingModel: self.model)
        mover = BasicMover(object: self.model.player, strategy: OneAxisMoveStrategy())
        spawner = RandomSideSpawner(racingModel: self.model)
        
        fsm = RacingStateMachine(scoreManager: self.scoreManager,
                                 spawner: self.spawner,
                                 lvlManager: self.lvlManager,
                                 colisionHandler: self.collisionHandler,
                                 mover: self.mover,
                                 racingModel: self.model)
    }
    
    func startGame() {
        fsm.start()
    }
    
    func pauseGame() {
        fsm.pause()
    }
    
    func userInput(with action: UserAction_t) {
        fsm.loop(UserAction.fromCAction(action))
        model.placeObjectOnField()
    }
    
    func endGame() {
        if let hScore = RacingInt(highscore.components(separatedBy: "\n").first?.components(separatedBy: " ").first ?? "0"),
           hScore > score {
            print("Higscore:", highscore)
        }
    }
}
