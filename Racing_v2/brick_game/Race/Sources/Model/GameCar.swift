//
//  GameCar.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 05.10.2024.
//

import Foundation

protocol GameObject {
    var xPos: RacingInt { get set }
    var yPos: RacingInt { get set }
}

protocol RacingCar: GameObject {
    var ySize: RacingInt { get }
    var xSize: RacingInt { get }
    var car: [[RacingInt]] { get }
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

class GameCar: RacingCar {
    let id: UUID = UUID()
    private var _xPos: RacingInt
    var xPos: RacingInt {
        get { self._xPos }
        set {
            if newValue >= 0 && newValue < RacingDefines.xBorderSize - xSize + 1 {
                self._xPos = newValue
            }
        }
    }
    var yPos: RacingInt
    
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
    
    init(xPos: RacingInt, yPos: RacingInt, car: [[RacingInt]]) {
        self._xPos = xPos
        self.yPos = yPos
        self.car = car
    }
}   // struct GameCar

extension GameCar : Equatable {
    static func == (lhs: GameCar, rhs: GameCar) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        return true
    }
}   // extension GameCar

class PlayerCar: GameCar {
    private var _isImmortal: RacingInt = 0
    
    var isImmortal: Bool {
          get { _isImmortal > 0 }
          set {
              if newValue {
                  self._isImmortal = RacingDefines.immortalFrames
              } else {
                  self._isImmortal = 0
              }
          }
      }

    func reduceImmortality() {
        if _isImmortal > 0 {
            _isImmortal -= 1
        }
    }
    
    required init(xPos: RacingInt = RacingDefines.xStartPos, yPos: RacingInt = RacingDefines.yStartPos + 6) {
        super.init(xPos: xPos, yPos: yPos, car: [[0, 1, 0],
                                                 [1, 1, 1],
                                                 [0, 1, 0],
                                                 [1, 1, 1]])
    }
    
}  // class PlayerCar


class EnemyCar: GameCar, EnemyRacingCar {
    required init(xPos: RacingInt, yPos: RacingInt = -6) {
        super.init(xPos: xPos, yPos: yPos, car: [[0, 2, 0],
                                                 [2, 2, 2],
                                                 [0, 2, 0],
                                                 [2, 2, 2],
                                                 [0, 2, 0]])
    }
}   //  class EnemyCar

extension EnemyCar: HasScorePrice {
    func getPrice() -> UInt16 {
        return CarPrice.defaultPrice
    }
}

class DotEnemy: GameCar, EnemyRacingCar {
    required init(xPos: RacingInt, yPos: RacingInt = -1) {
        super.init(xPos: xPos, yPos: yPos, car: [[2]])
    }
}

extension DotEnemy: HasScorePrice {
    func getPrice() -> UInt16 {
        return CarPrice.dotEnemyPrice
    }
}

class BlockEnemy: GameCar, EnemyRacingCar {
    required init(xPos: RacingInt, yPos: RacingInt = -2) {
        super.init(xPos: xPos, yPos: yPos, car: [[2, 2, 2],
                                                 [2, 2, 2]])
    }
}

extension BlockEnemy: HasScorePrice {
    func getPrice() -> UInt16 {
        return CarPrice.blockEnemyPrice
    }
}

class DoorEnemy: GameCar, EnemyRacingCar {

    required init(xPos: RacingInt, yPos: RacingInt = -4) {
        
        super.init(xPos: xPos, yPos: yPos, car: [[2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                                 [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                                 [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                                 [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2]])
    }
}

extension DoorEnemy: HasScorePrice {
    func getPrice() -> UInt16 {
        return CarPrice.doorWallPrice
    }
}

