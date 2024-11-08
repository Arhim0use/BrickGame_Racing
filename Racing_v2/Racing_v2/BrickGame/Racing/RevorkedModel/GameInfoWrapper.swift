//
//  ExtensionGameInfo.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 10.10.2024.
//

import Foundation

//import cFiles

enum UserAction: UInt16 {
    case start = 0
    case pause = 1
    case terminate = 2
    case moveLeft = 3
    case moveRight = 4
    case moveUp = 5
    case moveDown = 6
    case action = 7
    
    static func fromInput(_ rawValue: UInt32?) -> UserAction? {
        
        switch rawValue {
        case UnicodeScalar("s").value, UnicodeScalar("S").value:
            return .start
        case UnicodeScalar("p").value, UnicodeScalar("P").value:
            return .pause
        case UnicodeScalar("q").value, UnicodeScalar("Q").value:
            return .terminate
        case 0xffff-20:
            return .moveLeft
        case 0xffff-21:
            return .moveRight
        case 0xffff-18:
            return .moveUp
        case 0xffff-19:
            return .moveDown
        case 0x20:
            return .action
        default:
            return nil
        }
    }
    
    static func == (lhs: UserAction, rhs: UserAction_t) -> Bool {
        return lhs.toCAction() == rhs
    }

    static func == (lhs: UserAction_t, rhs: UserAction) -> Bool {
        return rhs.toCAction() == lhs
    }
    
    func toCAction() -> UserAction_t {
        switch self {
        case .start:
            return Start
        case .pause:
            return Pause
        case .terminate:
            return Terminate
        case .moveLeft:
            return Left
        case .moveRight:
            return Right
        case .moveUp:
            return Up
        case .moveDown:
            return Down
        case .action:
            return Action
        }
    }

    static func fromCAction(_ action: UserAction_t) -> UserAction? {
        switch action {
        case Start:
            return .start
        case Pause:
            return .pause
        case Terminate:
            return .terminate
        case Left:
            return .moveLeft
        case Right:
            return .moveRight
        case Up:
            return .moveUp
        case Down:
            return .moveDown
        case Action:
            return.action
        default:
            return nil
        }
    }
}

class GameInfoWrapper {
    enum GameState: RacingInt {
        case gameEnd = 0
        case gameRun = 1
        case gamePause = 2
    }
    
    var gameInfo: GameInfo_t
    
    var gameState: GameState {
        get {
            return GameState(rawValue: RacingInt(gameInfo.pause)) ?? .gameEnd
        }
        set {
            gameInfo.pause = Int32(newValue.rawValue)
        }
    }

    init() {
        
        let field = Array(repeating: Array(repeating: Int32(0), count: RacingDefines.xBorderSize), count: RacingDefines.yBorderSize)
        
        func matrixInit(matrix: [[Int32]]) -> UnsafeMutablePointer<UnsafeMutablePointer<Int32>?> {
            let fieldPointer = UnsafeMutablePointer<UnsafeMutablePointer<Int32>?>.allocate(capacity: matrix.count)
            
            for i in 0..<matrix.count {
                let rowPointer = UnsafeMutablePointer<Int32>.allocate(capacity: matrix[i].count)
                rowPointer.initialize(from: matrix[i], count: matrix[i].count)
                fieldPointer[i] = rowPointer
            }
            return fieldPointer
        }
        
        let fieldPointer = matrixInit(matrix: field)
        
        self.gameInfo = GameInfo_t(
            field: fieldPointer,
            next: nil,
            score: 0,
            high_score: 0,
            level: 1,
            speed: 100,
            pause: 0
        )
    }
    
    deinit {
        if gameInfo.field != nil {
            matrixClear(matrix: &gameInfo.field)
        }
        if gameInfo.next != nil {
            matrixClear(matrix: &gameInfo.next)
        }
        print("🟡 gameInfoWrapper deinit")

    }
    
    private func matrixClear(matrix: inout UnsafeMutablePointer<UnsafeMutablePointer<Int32>?>) {
        
        for i in 0..<RacingDefines.yBorderSize {
            if let rowPointer = matrix[i] {
                rowPointer.deallocate()
            }
        }
        
        matrix.deallocate()
        
    }
    
    func printField() {
        guard let rowsPointer = gameInfo.field else {
            return
        }
        
        for j in 0..<RacingDefines.yBorderSize {
            if let row = rowsPointer[j] {
                for k in 0..<RacingDefines.xBorderSize {
                    var char = k == 4 ? "|" : " "
                    char = (j % 3 == 0) ? char : " "
                    char = row[k] < 1 ? char : "\(row[k] - 1)"
                    char = row[k] > 0 ? "⎕" : char
                    char = row[k] == 2 ? "@" : char
                    print(char, terminator: "")
                    
                }
                let char = j % 6 == 0 ? "=" : "\(j)"
                print(char)
            }
        }
        print("0123456789+")
    }
    
    func matrixIsAllocate() -> Bool {
        guard let rowsPointer = gameInfo.field else {
            return false
        }
        
        for j in 0..<RacingDefines.yBorderSize {
            guard rowsPointer[j] != nil else {
                return false
            }
        }
        return true
    }
    
}
