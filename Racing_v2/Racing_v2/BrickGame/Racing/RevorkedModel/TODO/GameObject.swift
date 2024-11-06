//
//  GameObject.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 04.11.2024.
//

import Foundation


class GameCarFabric: GameObject, Identifiable {
    let id: ObjectIdentifier = ObjectIdentifier(RacingModel.self)
    var xPos: RacingInt
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
        self.xPos = xPos
        self.yPos = yPos
        self.car = car
    }
}   // struct GameCarFabric

extension GameCarFabric: Equatable {
    static func == (lhs: GameCarFabric, rhs: GameCarFabric) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        return true
    }
}

class PlayerGameCar: GameCarFabric {
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
    
    func reduceImmortality() {
        if _isImmortal > 0 {
            _isImmortal -= 1
        }
    }
    
    required init(xPos: RacingInt = RacingDefines.xStartPos, yPos: RacingInt = RacingDefines.yStartPos) {
        super.init(xPos: xPos, yPos: yPos, car: [[0, 1, 0],
                                                 [1, 1, 1],
                                                 [0, 1, 0],
                                                 [1, 1, 1]])
    }
}   // class PlayerGameCar

class EnemyGameCar: GameCarFabric {
    required init(xPos: RacingInt, yPos: RacingInt = -6) {
        super.init(xPos: xPos, yPos: yPos, car: [[0, 2, 0],
                                                 [2, 2, 2],
                                                 [0, 2, 0],
                                                 [2, 2, 2],
                                                 [0, 2, 0]])
    }
}

extension EnemyGameCar: HasScorePrice {
    func getPrice() -> UInt16 {
        return 5
    }
}

class DoorGameCar: GameCarFabric {
    required init(xPos: RacingInt, yPos: RacingInt = -4) {
        super.init(xPos: xPos, yPos: yPos, car: [[2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                                 [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                                 [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2],
                                                 [2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2]])
    }
}

extension DoorGameCar: HasScorePrice {
    func getPrice() -> UInt16 {
        return 8
    }
}

class DotGameCar: GameCarFabric {
    required init(xPos: RacingInt, yPos: RacingInt = -1) {
        super.init(xPos: xPos, yPos: yPos, car: [[2]])
    }
}

extension DotGameCar: HasScorePrice {
    func getPrice() -> UInt16 {
        return 1
    }
}

class BlockGameCar: GameCarFabric {
    required init(xPos: RacingInt, yPos: RacingInt = -1) {
        super.init(xPos: xPos, yPos: yPos, car: [[2, 2, 2], [2, 2, 2]])
    }
}

extension BlockGameCar: HasScorePrice {
    func getPrice() -> UInt16 {
        return 2
    }
}
