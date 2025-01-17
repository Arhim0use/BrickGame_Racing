//
//  Movebel.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 08.11.2024.
//

import Foundation

protocol Movebel {
    func move(by position: (xPos: RacingInt, yPos: RacingInt))
}

protocol MoveStrategy {
    /// - Returns: shift to next pos
    func moveForvard() -> (xPos: RacingInt, yPos: RacingInt)
    /// - Returns: shift to next pos
    func moveBackvard() -> (xPos: RacingInt, yPos: RacingInt)
    /// - Returns: shift to next pos
    func moveLeft() -> (xPos: RacingInt, yPos: RacingInt)
    /// - Returns: shift to next pos
    func moveRight() -> (xPos: RacingInt, yPos: RacingInt)
}

class BasicMoveStrategyFabric: MoveStrategy {
    func moveForvard() -> (xPos: RacingInt, yPos: RacingInt) {
        return (0, -1)
    }
    
    func moveBackvard() -> (xPos: RacingInt, yPos: RacingInt) {
        return (0, 1)
    }
    
    func moveLeft() -> (xPos: RacingInt, yPos: RacingInt) {
        return (-1, 0)
    }
    
    func moveRight() -> (xPos: RacingInt, yPos: RacingInt) {
        return (1, 0)
    }
}

class ClassicMoveStrategy: BasicMoveStrategyFabric {
    override func moveForvard() -> (xPos: RacingInt, yPos: RacingInt) {
        return (0, 0)
    }
    
    override func moveBackvard() -> (xPos: RacingInt, yPos: RacingInt) {
        return (0, 0)
    }
    
    override func moveLeft() -> (xPos: RacingInt, yPos: RacingInt) {
        return (-3, 0)
    }
    
    override func moveRight() -> (xPos: RacingInt, yPos: RacingInt) {
        return (3, 0)
    }
}

class OneAxisMoveStrategy: BasicMoveStrategyFabric {
    override func moveForvard() -> (xPos: RacingInt, yPos: RacingInt) {
        return (0, 0)
    }
    
    override func moveBackvard() -> (xPos: RacingInt, yPos: RacingInt) {
        return (0, 0)
    }
}

class BasicMover: Movebel {
    var object: GameObject
    var moveSrategy: MoveStrategy
    
    init(object: GameObject, strategy: MoveStrategy) {
        self.object = object
        self.moveSrategy = strategy
    }
    
    func move(with input: UserAction) -> GameObject {
        switch input {
        case .moveLeft:
            move(by: moveSrategy.moveLeft())
        case .moveRight:
            move(by: moveSrategy.moveRight())
        case .moveUp:
            move(by: moveSrategy.moveForvard())
        case .moveDown:
            move(by: moveSrategy.moveBackvard())
        default:
            break
        }
        return object
    }
    
    func move(by position: (xPos: RacingInt, yPos: RacingInt)) {
        object.xPos += position.xPos
        object.yPos += position.yPos
    }
}

class EnemyMover {
    var model: RacingModel
    var dispatchTimer: DispatchSourceTimer?
    var frameDeley: TimeInterval { Double(model.speed) / 250 }
    
    init(model: RacingModel) {
        self.model = model
    }
    
    func startEnemyMovement() {
        stopEnemyMovement()
        setupTimer(with: frameDeley)
    }
    
    func stopEnemyMovement() {
        dispatchTimer?.cancel()
        dispatchTimer = nil
    }
    
    /// - Note: need observer to change speed for _re_ startEnemyMovement()
    func speedUp(_ action: UserAction?) -> Int32 {
        let lvl = Int(model.gameInfo.level)
        if action == .moveUp && model.speed != RacingDefines.speedArr[lvl] {
            model.speed = RacingDefines.speedArr[lvl]
        } else if model.speed != RacingDefines.speedArr[lvl - 1] {
            model.speed = RacingDefines.speedArr[lvl - 1]
        }
        return model.gameInfo.speed
    }
    
    private func setupTimer(with interval: TimeInterval) {
        let queue = DispatchQueue.global(qos: .background)
        dispatchTimer = DispatchSource.makeTimerSource(queue: queue)
        dispatchTimer?.schedule(deadline: .now(), repeating: interval)
        dispatchTimer?.setEventHandler { [weak self] in
            self?.moveEnemys()
        }
        dispatchTimer?.resume()
    }
    
    private func moveEnemys() {
        for var car in model.enemys where car.yPos < 21 {
            car.yPos += 1
        }
    }
    
    func pauseEnemyMovement(with state: BrickGameGameState) {
        if state == .pause {
            stopEnemyMovement()
        } else {
            startEnemyMovement()
        }
    }
}

