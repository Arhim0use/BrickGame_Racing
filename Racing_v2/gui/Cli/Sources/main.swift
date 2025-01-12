//
//  main.swift
//  cliBrickGame
//
//  Created by Chingisbek Anvardinov on 21.11.2024.
//

import Foundation

import Termbox

import Race

func game() {
    let gameMenu = GameMenu(menuItems: ["Racing", "HighScore", "Exit"])
    let windowFabric = BasicWindowFactory()
    let windowManager = WindowManager(currentWindow: gameMenu, windowFactory: windowFabric)
    
    TermboxSession.initialaze()
    while windowManager.WindowActive == .isRun {
        let input = TermboxSession.peekEvent(timeOut: 30)
        windowManager.userInput(with: input)
        windowManager.draw()
    }
    TermboxSession.shutdown()
}

game()
