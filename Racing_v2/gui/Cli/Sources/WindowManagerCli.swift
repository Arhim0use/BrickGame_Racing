//
//  WindowManagerCli.swift
//  cliBrickGame
//
//  Created by Chingisbek Anvardinov on 23.11.2024.
//

import Foundation

import Termbox

import Race
import CommonBrickGame

enum WindowActive {
    case isRun
    case isStop
}

class WindowManager {
    private var currentWindow: TerminalWindow
    private let windowFactory: WindowFactory
    private var _isRun: WindowActive = .isRun
    var WindowActive: WindowActive { get { _isRun } }
    
    init(currentWindow: TerminalWindow, windowFactory: WindowFactory) {
        self.currentWindow = currentWindow
        self.windowFactory = windowFactory
    }
    
    func switchTo(window name: String) -> TerminalWindow {
        clear()

        return windowFactory.create(window: name)
    }

    func userInput(with rawValue: UInt32?) {
        guard let window = currentWindow as? InputAwaiting else {
            return
        }
        
        let action = UserAction.fromInput(rawValue)?.toCAction()
        window.userInput(with: action, hold: false)
        
        changeWindow(action, window)
    }
    
    func draw() {
        currentWindow.drawWindow()
    }
    
    func clear() {
        for row in 0..<Termbox.height {
            for coll in 0..<Termbox.width {
                Termbox.clear()
                Termbox.put(x: coll, y: row, character: " ")
            }
        }
    }
    
    private func changeWindow(_ action: UserAction_t?, _ window: any InputAwaiting) {
        if action == Action {
            if let window = window as? GameMenu {
                let option = window.menuItems[window.selectedIdx]
                currentWindow = switchTo(window: option)
            } else if window is SaveWindow {
                currentWindow = switchTo(window: "")
            }
        } else if let window = window as? TerminalRacing,
                  window.brickGame.currentState == .end {
            currentWindow = switchTo(window: "SaveScore")
        } else if action == Terminate {
            if window is GameMenu {
                _isRun = .isStop
            } else {
                currentWindow = switchTo(window: "")
            }
        }
    }
    
}


class BasicWindowFactory: WindowFactory {
    func create(window fromOption: String) -> any TerminalWindow {
        switch fromOption {
        case "Racing":
            return TerminalRacing(brickGame: RacingViewModel())
        case "HighScore":
            return HighscoreWindow()
        case "SaveScore":
            return SaveWindow()
        default:
            return GameMenu(menuItems: ["Racing", "HighScore", "Exit"])
        }
    }
}
