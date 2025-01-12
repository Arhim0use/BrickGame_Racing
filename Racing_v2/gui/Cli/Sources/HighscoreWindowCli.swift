//
//  HighcoreWindowCli.swift
//  cliBrickGame
//
//  Created by Chingisbek Anvardinov on 25.11.2024.
//

import Foundation

import Termbox

import Race
import CommonBrickGame

class HighscoreWindow: TerminalWindow {
    var highscoreTable: String = ""
    let dataDecoder = BDHighscoreDecoder()
    let dataBase: BasicDataSourceHandler
    
    private let info = [ "Press 'q' to exit" ]
    
    init() {
        self.dataBase = BasicDataSourceHandler()

        getTable(top: 10)
    }
//    deinit { do { try dataBase?.deleteAll() } catch {} }
    
    private func getTable(top: UInt32) {
        var table = ""
        do {
            let data = try dataBase.read(top: Int(top))
            
            table = alligment(size: 15, "Top 10\n") + dataDecoder.toStr(top: top, of: data)
        } catch {
            table = "Error: can't read the highscore table:" + error.localizedDescription
        }
        
        self.highscoreTable = table
    }
    
    private func alligment(size: UInt8, _ str: String) -> String {
        guard size > str.count else {
            return str
        }
        return String(repeating: " ", count: Int(size) - str.count) + str
    }
    
    func drawWindow() {
        guard TermboxSession.isInitialazed else {
            return
        }
        Termbox.clear()
        
        let rows = highscoreTable.components(separatedBy: "\n")
        for (yIdx,var row) in rows.enumerated() {
            if yIdx != 0 {
                var words = row.components(separatedBy: ";")
                words[0] = alligment(size: 10, words[0])
                words[1] = alligment(size: 5, words[1])
                row = words.joined(separator: " | ")
            }
            for (char, xIdx) in zip(row.unicodeScalars, 0..<row.count) {
                Termbox.put(x: Int32(xIdx), y: Int32(yIdx), character: char)
            }
        }
        InfoPutter().updateHelp(with: info)
        
        Termbox.present()
    }
}

extension HighscoreWindow: InputAwaiting {
    func userInput(with action: UserAction_t?, hold: Bool) {
        Void()
    }
}
