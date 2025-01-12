//
//  SaveWindowCLI.swift
//  cliBrickGame
//
//  Created by Chingisbek Anvardinov on 24.11.2024.
//

import Foundation

import Termbox

import Race
import CommonBrickGame

class SaveWindow: TerminalWindow {
    private var selectedIdx = 1
    private var saveName = String(repeating: "A", count: 10)
    
    private let info: [String] = [
        "Press [↑ ↓] to change letter",
        "Press [← →] to change position",
        "Press 'Space' to save & out",
        "Press 'q' to exit"
        ]
    
    private let arrows = [" Save your result ",
                          " ↑↑↑↑↑↑↑↑↑↑ ", "",
                          " ↓↓↓↓↓↓↓↓↓↓ "]
    
    func drawWindow() {
        guard TermboxSession.isInitialazed else {
            return
        }
        
        Termbox.clear()
        
        drawNameElements(xOffcet: 0, yOffcet: 0)
        drawOther(xOffcet: 0, yOffcet: 0)
        InfoPutter().updateHelp(with: info)
        Termbox.present()
    }
    
    private func drawNameElements(xOffcet: Int32, yOffcet: Int32) {
        let name = "←" + saveName + "→"
        for (char, idx) in zip(name.unicodeScalars, xOffcet..<Int32(name.count)) {
            let fColor = (idx == selectedIdx) ? Attributes.white : Attributes.default
            let bColor = (idx == selectedIdx) ? Attributes.blue : Attributes.default
            Termbox.put(x: Int32(idx) + xOffcet, y: Int32(2) + yOffcet, character: char, foreground: fColor, background: bColor)
        }
    }
    
    private func drawOther(xOffcet: Int32, yOffcet: Int32) {
        for (row, str) in arrows.enumerated() {
            guard !str.isEmpty else { continue }
            printAt(xPos: 0, yPos: Int32(row), str: str)
        }
    }
    
    private func printAt(xPos: Int32, yPos: Int32, str: String,
        foreground: Attributes = .default, background: Attributes = .default) {

        for (char, xIdx) in zip(str.unicodeScalars, xPos..<Int32(str.count)) {
            Termbox.put(x: xIdx, y: yPos, character: char, foreground: foreground,
                background: background)
        }
    }
}   // class SaveWindow

extension SaveWindow: InputAwaiting {
    
    func userInput(with action: UserAction_t?, hold: Bool) {
        let idx = saveName.index(saveName.startIndex, offsetBy: selectedIdx - 1)
        let asciiChar = saveName[idx].asciiValue!
        
        switch action {
        case Left:
            selectedIdx = max(1, selectedIdx - 1)
        case Right:
            selectedIdx = min(saveName.count, selectedIdx + 1)
        case Up:
            let char = Character(Unicode.Scalar(min(asciiChar + 1, 124)))
            saveName.remove(at: idx)
            saveName.insert(char, at: idx)
        case Down:
            let char = Character(Unicode.Scalar(max(32, asciiChar - 1)))
            saveName.remove(at: idx)
            saveName.insert(char, at: idx)
        case Action:
            saveAction()
            deleteUnnecessary()
        case Terminate:
            deleteUnnecessary()
        default:
            break
        }
    }
    
    private func deleteUnnecessary() {
        do {
            let dataBase = BasicDataSourceHandler()
            try dataBase.delete(where: "")
        } catch { }
    }
    
    private func saveAction() {
        do {
            let dataBase = BasicDataSourceHandler()
            
            if saveName != String(repeating: " ", count: 10) {
                try dataBase.updateLast(with: saveName)
            }
        } catch { }
    }
    
} // extension SaveWindow: InputAwaiting
