//
//  File.swift
//  Race
//
//  Created by Chingisbek Anvardinov on 17.12.2024.
//

import Foundation

import CommonBrickGame

public protocol BricGameViewModel {
    var currentState: BrickGameGameState { get }
    var gameInfo: GameInfo_t { get }
    var score: RacingInt { get }
    var highscore: String { get }
    var lives: RacingInt { get }
    var level: RacingInt { get }
    var speed: RacingInt { get }
}

public protocol InputAwaiting {
    func userInput(with action: UserAction_t?, hold: Bool)
}

public protocol StateUpdateble {
    func updateCurrentState() -> GameInfo_t
}

@available(macOS 12.0, *)
extension RacingViewModel: InputAwaiting {
    public func userInput(with action: UserAction_t?, hold: Bool) {
        runGame(with: UserAction.fromCAction(action))

        gameInfo = model.placeObjectOnField()
    }
}

@available(macOS 12.0, *)
extension RacingViewModel: StateUpdateble {
    public func updateCurrentState() -> GameInfo_t {
        fsm.spawn()
        fsm.collision()
        return model.placeObjectOnField()
    }
}

@available(macOS 12.0, *)
public class RacingViewModel: BricGameViewModel {
    
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

    private(set) var dataBase: BasicDataSourceHandler
    
    public var currentState: BrickGameGameState { get { fsm.currentState } }
    
    public var lives: RacingInt { get { model.lives } }
    
    public var level: RacingInt { get { RacingInt(gameInfo.level) } }
    
    public var speed: RacingInt { get { RacingInt(2500 / gameInfo.speed)} }
    
    public var score: RacingInt { get { RacingInt(gameInfo.score) } }
    
    public var frameDelay: RacingInt { get { RacingInt(gameInfo.speed) } }

    public private(set) var gameInfo: GameInfo_t {
        didSet {
            if oldValue.speed != gameInfo.speed {
                enemyMover.startEnemyMovement()
            }
        }
    }
    
    public var highscore: String { get { String(getHighscore()) } }
    
    public init() {
        lvlManager = LVLHandler(gameModel: self.model)
        scoreManager = ScoreManager(racingModel: self.model)
        collisionHandler = CollisionHandler(racingModel: self.model)
        mover = BasicMover(object: self.model.player, strategy: OneAxisMoveStrategy())
        spawner = ClassicEnemySpawner(racingModel: self.model)
        enemyMover = EnemyMover(model: self.model)
        
        dataBase = BasicDataSourceHandler()
        
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
        model.gameInfoWrapper.gameState = .gameEnd
    }
    
    public func userInput(with action: UserAction_t?) {
        runGame(with: UserAction.fromCAction(action))

        gameInfo = model.placeObjectOnField()
    }
    
    /// - Note: TODO при рестарте либо удалять highscore либо давать Дефолт имя "..." последнему игроку
    func startGame(with action: UserAction?) {
        guard action == .start else {
            return
        }
        
        fsm.start()
        enemyMover.startEnemyMovement()
        initHigscore()
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

    func runGame(with action: UserAction?) {
        switch action {
        case .start:
            startGame(with: action)
        case .terminate:
            endGame(with: action)
        case .pause:
            pauseGame(with: action)
        default:
            model.speed = enemyMover.speedUp(action)
            fsm.loop(action)
            updateHighscore()
        }
    }
    
    func endGame(with action: UserAction?) {
        guard action == .terminate else {
            return
        }

        updateLastHS()
        
        fsm.end()
        enemyMover.stopEnemyMovement()
    }
    
    private func getHighscore() -> Int32 {
        updateHighscore()
        
        return model.highScore
    }
    
    private func updateHighscore() {
        guard score > model.highScore else {
            return
        }
        
        model.highScore = Int32(score)
    }
    
    private func initHigscore() {
        var hs: Int32 = 0
        
        do {
            if let top = try dataBase.read(top: 1).first {
                hs = Int32(top.score)
            }
        } catch {
            hs = 0
        }
        
        model.highScore = hs
    }
    
    private func updateLastHS() {
        do {
            try dataBase.create(name: "", score: score)
//            print("this score", score)
//            print("last score", try dataBase.readAll().last!)
        } catch { }
    }
}

