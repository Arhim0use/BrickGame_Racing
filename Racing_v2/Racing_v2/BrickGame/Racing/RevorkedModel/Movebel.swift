//
//  Movebel.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 07.11.2024.
//

import Foundation

protocol Movebel {
    func move(to position: (xPos: RacingInt, yPos: RacingInt))
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
    deinit {
        print("🛑 BasicMover deinit")
    }
    func move(with input: UserAction) -> GameObject {
        switch input {
        case .moveLeft:
            move(to: moveSrategy.moveLeft())
        case .moveRight:
            move(to: moveSrategy.moveRight())
        case .moveUp:
            move(to: moveSrategy.moveForvard())
        case .moveDown:
            move(to: moveSrategy.moveBackvard())
        default:
            break
        }
        return object
    }
    
    func move(to position: (xPos: RacingInt, yPos: RacingInt)) {
        object.xPos += position.xPos
        object.yPos += position.yPos
    }
}
