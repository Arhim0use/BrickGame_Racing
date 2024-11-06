//
//  Field.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 05.10.2024.
//

import Foundation

//import cFiles




fileprivate let input: UserAction? = nil




protocol PREV_GameModel : AnyObject {
    func startGame()
    func runGame()
    
    func playerAction(action: UserAction_t, value: RacingInt)
    func updateScore()
    func updateBoard()
    func spawnNext()
    func gameIsOver() -> Bool
    func getGameInfo() -> GameInfo_t
    
    func updateGameInfo() -> GameInfo_t
}

class PREV_RacingModel : PREV_GameModel {
    var player: PlayerCar
    var enemys: [EnemyRacingCar] = []
    var gameInfoWr: GameInfoWrapper
    var gameInfo: GameInfo_t {
        get { gameInfoWr.gameInfo }
    }
    
    /// - Note: count of player lives
    var livesCount: RacingInt = RacingDefines.startLiveCount
    
    private var _colisionChecker: PREV_CollisionCheckable = PREV_CollisionHandler()
    private var _spawner: PREV_EnemySpawner = BasicEnemySpawner()
    private var _levelManager: PREV_Scorable = AdvancedLevelManager()
    private var _racingFSM: PREV_FinalStateMachine = PREV_RacingStateMachine()
    
    /// - Note: collision verification policy
    var colisionChecker: PREV_CollisionCheckable {
        get { _colisionChecker }
        set {
            _colisionChecker = newValue
            _colisionChecker.racingModel = self
        }
    }
    
    /// - Note: policy for creating new objects
    var spawner: PREV_EnemySpawner {
        get { self._spawner }
        set {
            self._spawner = newValue
            self._spawner.enemyType = [EnemyCar.self, /*SmallEnemy.self*/]
            self._spawner.racingModel = self
        }
    }
    
    var spawnTypes: [EnemyRacingCar.Type] {
        get { _spawner.enemyType }
        set { _spawner.enemyType = newValue }
    }
    
    /// - Note: Keeps track of the score and changes levels
    var levelManager: PREV_Scorable {
        get { self._levelManager }
        set {
            _levelManager = newValue
            _levelManager.racingModel = self
        }
    }
    
    var racingFSM: PREV_FinalStateMachine {
        get { self._racingFSM }
        set {
            _racingFSM = newValue
            _racingFSM.gameModel = self
        }
    }
    
    deinit {
            print("⚠️ RacingModel deinit ")
    }
    
    init() {
        self.player = PlayerCar()
        self.gameInfoWr = GameInfoWrapper()
        
        _levelManager.racingModel = self
        
        _colisionChecker.racingModel = self
        
        _spawner.racingModel = self
        _spawner.enemyType = [EnemyCar.self, SmallEnemy.self]
        
        _racingFSM.gameModel = self

        while enemys.isEmpty {
            spawnNext()
        }
    }
    
    init(gameInfoWrapper: GameInfoWrapper) {
        self.player = PlayerCar()
        self.gameInfoWr = gameInfoWrapper
        
        _levelManager.racingModel = self
        
        _colisionChecker.racingModel = self
        
        _spawner.racingModel = self
        _spawner.enemyType = [EnemyCar.self]
        
        _racingFSM.gameModel = self

        while enemys.isEmpty {
            spawnNext()
        }
    }
    
    public func startGame() {
        racingFSM.start()
        restartGame()
    }
    
    public func runGame() {
        while racingFSM.currentState != .end {
            racingFSM.gameLoop(input)
        }
    }
    
    public func pauseGame() {
        let switchState: BrickGameGameState = racingFSM.currentState != .pause ? .pause : .moving
        
        if let fsm = _racingFSM as? PREV_RacingStateMachine {
            fsm.setState(switchState)
        }
    }
    
    /// - Returns: GameInfo_t sruct from C header
    func getGameInfo() -> GameInfo_t {
        return gameInfoWr.gameInfo
    }
    
    /// - Note: place Cars matrix on Field matrix
    func updateGameInfo() -> GameInfo_t {
        placeCarsToField()
        return gameInfoWr.gameInfo
    }
    
    /// - Note: Struct GameInfo to default( score, lvl, speed), clear field, enemys and spawn new enemy
    func restartGame() {
        guard gameInfoWr.matrixIsAllocate() else {
            return
        }
        
        gameInfoWr.gameState = .gameRun
        gameInfoWr.gameInfo.score = 0
        gameInfoWr.gameInfo.level = 0
        gameInfoWr.gameInfo.speed = 1

        self.player = PlayerCar()
        self.enemys.removeAll()
        while enemys.isEmpty {
            spawnNext()
        }
        
        placeCarsToField()
    }
    
    /// - Note: move player car
    func playerAction(action: UserAction_t, value: RacingInt) {
        if player.xPos + value >= 0 || player.xPos + player.car.xSize + value < RacingDefines.xBorderSize {
            player.xPos += value
        }
    }
    
    /// - Note: reduse and check lives count
    func gameIsOver() -> Bool {
        if colisionChecker.check() {
            livesCount -= 1
        }

        if livesCount <= 0 {
            gameInfoWr.gameState = .gameEnd
            return true
        }

        return false
    }
    
    /// - Note: increast score and select spanw logic depeded on score
    func updateScore() {
        _levelManager.addPoints()
    }
    
    /// - Note: field update except for player actions
    func updateBoard() {
        for i in enemys.indices {
            enemys[i].yPos += 1
        }
    }
    
    /// - Note: spawn new element
    func spawnNext() {
        _spawner.spawnNext()
    }
    
    private func clearField() {
        for y in 0..<RacingDefines.yBorderSize {
            for x in 0..<RacingDefines.xBorderSize {
                gameInfoWr.gameInfo.field[y]![x] = 0
            }
        }
    }
    
    private func placeCarsToField() {
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

                if gameInfoWr.gameInfo.field[fieldY]![fieldX] == 0 {
                    gameInfoWr.gameInfo.field[fieldY]![fieldX] = Int32(rCar.car.car[carRow][carCell])
                }
            }
        }
    }
    
}   // RacingModel
