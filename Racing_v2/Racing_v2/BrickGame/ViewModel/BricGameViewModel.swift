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
    
    private(set) var enemyMover: EnemyMover
    
    private(set) var collisionHandler: CollisionHandler {
        willSet {
            fsm.colisionHandler = newValue
        }
    }

    private var dataBase: BrickGameDataSource? = nil
    
    var currentState: BrickGameGameState { get { fsm.currentState } }
    
    var lives: RacingInt { get { model.lives } }
    
    var level: RacingInt { get { RacingInt(gameInfo.level) } }
    
    var speed: RacingInt { get { RacingInt(1000 / gameInfo.speed)} }
    
    var score: RacingInt { get { RacingInt(gameInfo.score) } }
    
    var frameDelay: RacingInt { get { RacingInt(gameInfo.speed) } }
    
    @Published private(set) var gameInfo: GameInfo_t
    
    var highscore: String { get { String(getHighscore()) } }
    
    init() {
        lvlManager = LevelHandler(gameModel: self.model)
        scoreManager = ScoreManager(racingModel: self.model)
        collisionHandler = CollisionHandler(racingModel: self.model)
        mover = BasicMover(object: self.model.player, strategy: OneAxisMoveStrategy())
        spawner = ClassicEnemySpawner(racingModel: self.model)
        enemyMover = EnemyMover(model: self.model)
        
        do {
            self.dataBase = try BrickGameDataSource()
            //            try dataBase?.deleteAll()
            
        } catch { }
        
        fsm = RacingStateMachine(scoreManager: self.scoreManager,
                                 spawner: self.spawner,
                                 lvlManager: self.lvlManager,
                                 colisionHandler: self.collisionHandler,
                                 mover: self.mover,
                                 racingModel: self.model)
        gameInfo = GameInfoWrapper().gameInfo
        initHigscore()
    }
    deinit {
        print("🛑 RacingViewModel deinit")
    }
    func startGame(with action: UserAction?) {
        guard action == .start else {
            return
        }
        do {
            try dataBase?.create(new: PersonHighscore(name: "AAAAA"))
        } catch { }
        initHigscore()
        
        fsm.start()
        enemyMover.startEnemyMovement()
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
        enemyMover.pauseEnemyMovement(with: currentState)
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
            updateHighscore()
        }
    }
    
    func endGame(with action: UserAction?) {
        guard action == .terminate else {
            return
        }
        fsm.end()
        enemyMover.stopEnemyMovement()
        updateHighscore()
    }
    
    func getHighscore() -> Int32 {
        updateHighscore()
        
        return model.highScore
    }
    
    func updateHighscore() {
        guard score > model.highScore else {
            return
        }
        
        model.highScore = Int32(score)
        
        guard let dataBase = self.dataBase else {
            return
        }
        
        do {
            if let top = BDHighscoreDecoder().toIntArr(top: 1, of: dataBase.readAll()).first {
                model.highScore = Int32(top)
            }
            try dataBase.updateLast(with: score)
        } catch { }
    }
    
    func initHigscore() {
        guard let dataBase = self.dataBase else {
            return
        }
        
        if let top = BDHighscoreDecoder().toIntArr(top: 1, of: dataBase.readAll()).first {
            model.highScore = Int32(top)
        }
    }
}
