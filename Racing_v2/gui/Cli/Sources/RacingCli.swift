//
//  RacingCli.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 09.10.2024.
//

import Foundation

import Termbox

import Race
import CommonBrickGame

struct WindowDefines {
    static let borderWidth: RacingInt = 1
    static let offset: RacingInt = 2

    static let gameWidghSize: RacingInt = borderWidth + 2 * RacingDefines.xBorderSize
    static let gameHightSize: RacingInt = RacingDefines.yBorderSize
    
    static let gameXPos: RacingInt = borderWidth
    static let gameYPos: RacingInt = borderWidth
    
    /// - Note: for tetris
    static let nextElementWidgh: RacingInt = nextElementHight * 2
    /// - Note: for tetris
    static let nextElementHight: RacingInt = 6
    static let nextElementXPos: RacingInt = 2 * borderWidth + gameWidghSize + offset
    static let nextElementYPos: RacingInt = borderWidth + offset - 1
    
    static let maxNameLen: RacingInt = 6
    static let minNameLen: RacingInt = 3
    static let infoTableWidthSize: RacingInt = nextElementWidgh
    static let infoTableHightSize: RacingInt = 9
    
    static let infoTableXPos: RacingInt = nextElementXPos
    static let infoTableYPos: RacingInt = nextElementYPos + nextElementHight + offset
    
    static let gameWindowWidghSize: RacingInt = 3 * borderWidth + gameWidghSize + infoTableWidthSize + 2 * offset
    static let gameWindowHeighSize: RacingInt = 2 * borderWidth + gameHightSize
    

    static let borderElement = "–"
    static let playerElement = "🀫"
    static let enemyElement = "⎕"
    
}   // struct WindowDifines


@available(macOS 10.15, *)
class TerminalRacing: GameWindow {
    let brickGame: BricGameViewModel
    
    private var window: [[String]]
    private let info = [
        "Press [← ↑ →] to move",
        "Press 's' to restart",
        "Press 'p' to pause/unpause",
        "Press 'q' to exit"
    ]
    
    init(brickGame: BricGameViewModel) {
        self.brickGame = brickGame
        self.window = Array(repeating: Array(repeating: " ", count: WindowDefines.gameWindowWidghSize), count: WindowDefines.gameWindowHeighSize)
    }
    
    private func selectColor(char: String) -> Attributes {
        guard char.count == 1 else {
            return Attributes.default
        }
        
        switch char {
        case WindowDefines.borderElement:
            return Attributes.green
        case WindowDefines.enemyElement:
            return Attributes.red
        case WindowDefines.playerElement:
            return Attributes.magenta
        default:
            return Attributes.default
        }
    }
    
    private func putCell(_ cell: Int, _ row: Int, _ color: Attributes) {
        Termbox.put(x: Int32(cell), y: Int32(row), character: window[row][cell].toUnicodeScalar(), foreground: color, background: color)
    }
    
    func gameWindow() {
        for row in 0..<window.count {
            for cell in 0..<window[row].count {
                placeBorder(xPos: cell, yPos: row)
                placeInfo(xPos: cell, yPos: row)
                placeGame(xPos: cell, yPos: row)
            }
        }
    }
    
    private func placeBorder(xPos: RacingInt, yPos: RacingInt) {
        if yPos == 0 || yPos == WindowDefines.gameWindowHeighSize - 1 {
            window[yPos][xPos] = WindowDefines.borderElement
        } else if xPos == 0 || xPos == WindowDefines.gameWidghSize || xPos == WindowDefines.gameWindowWidghSize - 1 {
            window[yPos][xPos] = WindowDefines.borderElement
        }
        
        if xPos > WindowDefines.gameWidghSize {
            placeInfoBorder(xPos, yPos)
        }
    }
    
    private func placeGame(xPos: RacingInt, yPos: RacingInt) {
        guard xPos % 2 == 0, let vModel = brickGame as? RacingViewModel else {
            return
        }
        
        guard let gameMatrix = vModel.updateCurrentState().field else {
            return
        }
        
        if yPos >= WindowDefines.borderWidth && yPos < WindowDefines.borderWidth + WindowDefines.gameHightSize {
            if let gameRow = gameMatrix[yPos - WindowDefines.borderWidth], xPos >= 0 && xPos < WindowDefines.gameWidghSize {
                
                var cell = RacingInt(gameRow[xPos / 2]) == 1 ? WindowDefines.playerElement : " "
                cell = RacingInt(gameRow[xPos / 2]) == 2 ? WindowDefines.enemyElement : cell
                
                window[yPos][xPos + WindowDefines.borderWidth] = cell
                window[yPos][xPos + WindowDefines.borderWidth + 1] = cell
            }
        }
    }

    private func placeInfo(xPos: RacingInt, yPos: RacingInt) {
        guard yPos >= WindowDefines.infoTableYPos, xPos > WindowDefines.infoTableXPos else {
            return
        }
        
        let score = brickGame.score < 1_000 ? brickGame.score : 999
        let info = """
         Lives: \(brickGame.lives)
         Level: \(brickGame.level)
         Score: \(score)
         Speed: \(brickGame.speed)
            
         Hightscore
         \(higscore())
        """
        
        let infoXPos = xPos - WindowDefines.infoTableXPos - 1
        let infoYPos = yPos - WindowDefines.infoTableYPos
        let lines = info.components(separatedBy: "\n")
        
        if infoYPos >= 0 && infoYPos < lines.count , infoXPos >= 0 && infoXPos < lines[infoYPos].count {
            let character = lines[infoYPos][lines[infoYPos].index(lines[infoYPos].startIndex, offsetBy: infoXPos)]
            window[yPos][xPos] = String(character)
        } else if xPos <= WindowDefines.infoTableXPos + WindowDefines.infoTableWidthSize
                    && yPos <= WindowDefines.infoTableYPos + WindowDefines.infoTableHightSize {
            window[yPos][xPos] = " "
        }

    }
    
    private func higscore() -> String {
        var hsPos = 1 + WindowDefines.infoTableWidthSize / 2 - "\(brickGame.highscore)".count
        if hsPos < 0 {
            hsPos = 0
        }
        return String(repeating: " ", count: hsPos) + "\(brickGame.highscore)"
    }
    
    private func placeInfoBorder(_ xPos: RacingInt, _ yPos: RacingInt) {
        let downDelimetr = WindowDefines.nextElementYPos + WindowDefines.nextElementHight
        let rightdBorder = xPos > WindowDefines.nextElementXPos + WindowDefines.nextElementWidgh
        if !(yPos > WindowDefines.nextElementYPos && xPos > WindowDefines.nextElementXPos)
            || (yPos > WindowDefines.nextElementYPos && rightdBorder)
            || (yPos >= downDelimetr && yPos < WindowDefines.infoTableYPos )
            || (yPos > WindowDefines.infoTableYPos + WindowDefines.infoTableHightSize)
        {
            window[yPos][xPos] = WindowDefines.borderElement
        }
    }
    
}   // class TerminalRacing

extension String {
    func toUnicodeScalar() -> UnicodeScalar {
        guard self.count == 1, let scalar = self.unicodeScalars.first else {
            return UnicodeScalar("0")
        }
        return scalar
    }
}

extension TerminalRacing: InputAwaiting {
    func userInput(with action: UserAction_t?, hold: Bool) {
        guard let game = brickGame as? RacingViewModel else {
            return
        }
        
        game.userInput(with: action, hold: hold)
    }
}

extension TerminalRacing: TerminalWindow {
    func drawWindow() {
        guard TermboxSession.isInitialazed else {
            return
        }
        
        gameWindow()
        Termbox.clear()
        for row in 0..<window.count {
            for cell in 0..<window[row].count {
                let color = selectColor(char: window[row][cell])
                
                putCell(cell, row, color)
            }
        }

        InfoPutter().updateHelp(with: info)
        Termbox.present()
    }
    
}
