//
//  Car.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 05.10.2024.
//

import Foundation

protocol RacingCar {
    var xPos: RacingInt { get set }
    var yPos: RacingInt { get set }
    var car: GameCar { get }
}   // protocol RacingCar

protocol EnemyRacingCar : RacingCar {
    init(xPos: RacingInt, yPos: RacingInt)
}  //  protocol EnemyRacingCar

protocol HasScorePrice {
    func getPrice() -> UInt16
}

struct CarPrice {
    static let defaultPrice: UInt16 = 5
    static let dotEnemyPrice: UInt16 = 1
    static let blockEnemyPrice: UInt16 = 2
    static let doorWallPrice: UInt16 = 8
}

struct GameCar {
    enum CarType {
        case Player, Enemy
    }
    var type: CarType
    var car: [[RacingInt]]
    var xSize: RacingInt {
        get {
            guard let row = car.first else {
                return 0
            }
            return row.count
        }
    }
    var ySize: RacingInt { get { return car.count } }
    
    init(type: CarType) {
        self.type = type
        switch type {
        case .Player:
            self.car = [[0, 1, 0],
                        [1, 1, 1],
                        [0, 1, 0],
                        [1, 1, 1]]
        case .Enemy:
            self.car = [[0, 2, 0],
                        [2, 2, 2],
                        [0, 2, 0],
                        [2, 2, 2],
                        [0, 2, 0]]
        }
    }
    
    init(type: CarType, car: [[RacingInt]]) {
        self.type = type
        self.car = car
    }
}   // struct GameCar

extension GameCar : Equatable {
    static func == (lhs: GameCar, rhs: GameCar) -> Bool {
        if lhs.type != rhs.type || lhs.xSize != rhs.xSize
            || lhs.ySize != rhs.ySize || lhs.car != rhs.car {
            return false
        }
        return true
    }
}   // extension GameCar

class PlayerCar: RacingCar {
    var xPos: RacingInt
    var yPos: RacingInt
    var car: GameCar
    private var _isImmortal: RacingInt = 0
    var isImmortal: Bool {
          get { _isImmortal > 0 }
          set {
              if newValue {
                  self._isImmortal = RacingDefines.immortalFrames // Устанавливаем количество кадров для неуязвимости
              } else {
                  self._isImmortal = 0
              }
          }
      }
    
    init() {
        self.car = GameCar(type: .Player)
        self.xPos = RacingDefines.xStartPos
        self.yPos = RacingDefines.yStartPos - car.ySize
    }
    
    func reduceImmortality() {
        if _isImmortal > 0 {
            _isImmortal -= 1
        }
    }
}  // class PlayerCar


class EnemyCar: RacingCar, EnemyRacingCar {
    var xPos: RacingInt
    var yPos: RacingInt
    var car: GameCar
    
    init() {
        self.car = GameCar(type: .Enemy)
        self.xPos = 0
        self.yPos = -car.ySize
    }
    
    required init(xPos: RacingInt, yPos: RacingInt = -6) {
        self.car = GameCar(type: .Enemy)
        self.xPos = xPos
        self.yPos = yPos
    }
}   //  class EnemyCar

extension EnemyCar: HasScorePrice {
    func getPrice() -> UInt16 {
        return CarPrice.defaultPrice
    }
}

class SmallEnemy: EnemyRacingCar {
    var xPos: RacingInt
    var yPos: RacingInt
    var car: GameCar
    
    init() {
        self.car = GameCar(type: .Enemy, car: [[0, 2, 0],
                                               [2, 2, 2],
                                               [2, 2, 2]])
        self.xPos = 0
        self.yPos = -car.ySize
    }
    
    required init(xPos: RacingInt, yPos: RacingInt = -3) {
        self.car = GameCar(type: .Enemy, car: [[0, 2, 0],
                                               [2, 2, 2],
                                               [2, 2, 2]])

        self.xPos = xPos
        self.yPos = yPos
    }
}

extension SmallEnemy: HasScorePrice {
    func getPrice() -> UInt16 {
        return CarPrice.defaultPrice
    }
}

class DotEnemy: EnemyRacingCar {
    var xPos: RacingInt
    var yPos: RacingInt
    var car: GameCar
    
    init() {
        self.car = GameCar(type: .Enemy, car: [[2]])
        self.xPos = 0
        self.yPos = -car.ySize
    }
    
    required init(xPos: RacingInt, yPos: RacingInt = -1) {
        self.car = GameCar(type: .Enemy, car: [[2]])
        self.xPos = xPos
        self.yPos = yPos
    }
}

extension DotEnemy: HasScorePrice {
    func getPrice() -> UInt16 {
        return CarPrice.dotEnemyPrice
    }
}

class BlockEnemy: EnemyRacingCar {
    var xPos: RacingInt
    var yPos: RacingInt
    var car: GameCar
    
    init() {
        self.car = GameCar(type: .Enemy, car: [[2, 2, 2],
                                               [2, 2, 2]])
        self.xPos = 0
        self.yPos = -car.ySize
    }
    
    required init(xPos: RacingInt, yPos: RacingInt = -2) {
        self.car = GameCar(type: .Enemy, car: [[2, 2, 2],
                                               [2, 2, 2]])
        self.xPos = xPos
        self.yPos = yPos
    }
}

extension BlockEnemy: HasScorePrice {
    func getPrice() -> UInt16 {
        return CarPrice.blockEnemyPrice
    }
}

class DoorEnemy: EnemyRacingCar {
    var xPos: RacingInt
    var yPos: RacingInt
    var car: GameCar
    
    init() {
        self.car = GameCar(type: .Enemy, car: [[2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                               [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                               [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                               [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2]])
        self.xPos = 0
        self.yPos = -car.ySize
    }
    
    required init(xPos: RacingInt, yPos: RacingInt = -4) {
        self.car = GameCar(type: .Enemy, car: [[2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                               [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                               [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                               [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2]])
        self.xPos = xPos
        self.yPos = yPos
    }
}

extension DoorEnemy: HasScorePrice {
    func getPrice() -> UInt16 {
        return CarPrice.doorWallPrice
    }
}
