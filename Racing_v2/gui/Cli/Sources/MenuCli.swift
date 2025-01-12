//
//  MenuCli.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 11.10.2024.
//

import Foundation

import Termbox

import Race
import CommonBrickGame

class GameMenu: MenuSelectable {
    var menuItems: [String]
    var selectedIdx = 0

    private let info: [String] = [
        "Press [↑ ↓] to change row",
        "Press 'Space' to select",
        "Press 'q' to exit"
        ]
    
    required init(menuItems: [String]) {
        self.menuItems = menuItems
    }
    
    private func drawMenuElements() {
        Termbox.clear()
        
        for (idx, item) in menuItems.enumerated() {
            let fColor = (idx == selectedIdx) ? Attributes.white : Attributes.default
            let bColor = (idx == selectedIdx) ? Attributes.blue : Attributes.default
            
            for (i, char) in item.enumerated() {
                let char = UnicodeScalar(UInt8(char.unicodeScalars.first!.value))
                Termbox.put(x: Int32(i), y: Int32(idx), character: char, foreground: fColor, background: bColor)
            }
        }
        
        InfoPutter().updateHelp(with: info)
        Termbox.present()
    }
    
} // GameMenu

extension GameMenu : TerminalWindow {
    func drawWindow() {
        guard TermboxSession.isInitialazed else {
            return
        }
        
        drawMenuElements()
    }
}

extension GameMenu: InputAwaiting {
    func userInput(with action: UserAction_t?, hold: Bool) {
        switch action {
        case Up:
            selectedIdx = max(0, selectedIdx - 1)
        case Down:
            selectedIdx = min(menuItems.count - 1, selectedIdx + 1)
        default:
            break
        }
    }
}
