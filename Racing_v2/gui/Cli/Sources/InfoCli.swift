//
//  InfoCli.swift
//  cliBrickGame
//
//  Created by Chingisbek Anvardinov on 22.11.2024.
//

import Foundation

import Termbox

class InfoPutter {
    func updateHelp(with info: [String]) {
        guard TermboxSession.isInitialazed else {
            return
        }

        let lastY = Termbox.height - 1
        let content = info.joined(separator: " | ")
        
        var filler = ""
        if Int(Termbox.width) - content.unicodeScalars.count > 0 {
            filler = String(repeating: " ",
                                count: Int(Termbox.width) - content.unicodeScalars.count)
        }
        
        printAt(x: 0, y: lastY, text: content + filler, foreground: .white,
            background: .blue)
    }
    
    private func printAt(x: Int32, y: Int32, text: String,
        foreground: Attributes = .default, background: Attributes = .default) {
        let border = Termbox.width

        for (c, xi) in zip(text.unicodeScalars, x ..< border) {
            Termbox.put(x: xi, y: y, character: c, foreground: foreground,
                background: background)
        }
    }
}
