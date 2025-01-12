//
//  WindowProtocols.swift
//  cliBrickGame
//
//  Created by Chingisbek Anvardinov on 23.11.2024.
//

import Foundation

import Race

protocol WindowFactory {
    func create(window from: String) -> TerminalWindow
}

protocol GameWindow {
    var brickGame: BricGameViewModel { get }
    func gameWindow()
}

protocol TerminalWindow {
    func drawWindow()
}

protocol MenuSelectable {
    var menuItems: [String] { get }
    var selectedIdx: Int { get }
    init(menuItems: [String])
}
