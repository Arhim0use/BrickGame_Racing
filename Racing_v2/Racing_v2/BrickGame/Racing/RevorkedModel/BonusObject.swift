//
//  BonusObject.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 04.11.2024.
//

import Foundation

protocol BonusObject: GameObject {
    init(xPos: RacingInt, yPos: RacingInt)
}

protocol BonusState {
    func setBonus() -> Bool
}

class BonusFabric: BonusObject {
    required init(xPos: RacingInt, yPos: RacingInt) {
        self._xPos = xPos
        self._yPos = yPos
        self._isPickedUp = false
    }
    
    var _xPos: RacingInt
    var _yPos: RacingInt
    var _isPickedUp: Bool
    
    var xPos: RacingInt {
        get { self._xPos }
        set {
            guard newValue > 0 else {
                return
            }
        }
    }
    
    var isPickedUp: Bool {
        get { self._isPickedUp }
        set {
            guard newValue == true else {
                return
            }
            _isPickedUp = newValue
        }
    }
    
    var yPos: RacingInt {
        get { self.xPos }
        set {
            guard newValue > 0 else {
                return
            }
            self._yPos = newValue
        }
    }
}

class HealUp: BonusFabric, BonusState {
    var healCount: RacingInt = 1
    
    /// отправить уведомление что у игрока + HP
    func setBonus() -> Bool {
        guard !isPickedUp else {
            return false
        }
        isPickedUp = true
        return isPickedUp
    }
}
