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
    
    func startGame(with action: UserAction?)
    func pauseGame(with action: UserAction?)
    func runGame(with action: UserAction?)
    func userInput(with action: UserAction_t?)
    func endGame(with action: UserAction?)
}

@available(macOS 10.15, *)
class RacingViewModel: ObservableObject, BricGameViewModel {
    
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
    
    var currentState: BrickGameGameState { get { fsm.currentState } }
    
    var lives: RacingInt { get { model.lives } }
    
    var level: RacingInt { get { RacingInt(gameInfo.level) } }
    
    var speed: RacingInt { get { RacingInt(1000 / gameInfo.speed)} }

    var score: RacingInt { get { RacingInt(gameInfo.score) } }
    
    var frameDelay: RacingInt { get { RacingInt(gameInfo.speed) } }

    @Published private(set) var gameInfo: GameInfo_t

    var highscore: String = ""
    
    init() {
        lvlManager = LevelHandler(gameModel: self.model)
        scoreManager = ScoreManager(racingModel: self.model)
        collisionHandler = CollisionHandler(racingModel: self.model)
        mover = BasicMover(object: self.model.player, strategy: OneAxisMoveStrategy())
        spawner = ClassicEnemySpawner(racingModel: self.model)
        
        fsm = RacingStateMachine(scoreManager: self.scoreManager,
                                 spawner: self.spawner,
                                 lvlManager: self.lvlManager,
                                 colisionHandler: self.collisionHandler,
                                 mover: self.mover,
                                 racingModel: self.model)
        gameInfo = GameInfoWrapper().gameInfo
    }
    deinit {
        print("🛑 RacingViewModel deinit")
    }
    func startGame(with action: UserAction?) {
        guard action == .start else {
            return
        }
        fsm.start()
    }
    
    func pauseGame(with action: UserAction?) {
        guard action == .pause else {
            return
        }
        if currentState == .pause {
            fsm.resume()
        } else {
            fsm.pause()
        }
    }
    
    func userInput(with action: UserAction_t?) {
        runGame(with: UserAction.fromCAction(action))

        gameInfo = model.placeObjectOnField()
    }
    
    func runGame(with action: UserAction?) {
        switch action {
        case .start:
            startGame(with: action)
        case .terminate:
            endGame(with: action)
        case .pause:
            
            pauseGame(with: action)
        default:
            fsm.loop(action)
        }
    }
    
    func endGame(with action: UserAction?) {
        guard action == .terminate else {
            return
        }
        fsm.setState(.end)
        if let hScore = RacingInt(highscore.components(separatedBy: "\n").first?.components(separatedBy: " ").first ?? "0"),
           hScore > score {
            print("Higscore:", highscore)
        }
    }
}
