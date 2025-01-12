//
//  TXTDataSource.swift
//  Racing
//
//  Created by Chingisbek Anvardinov on 09.12.2024.
//

import Foundation

@available(macOS 12.0, *)
class HigscoreTXTDataSource {
    let fileManger: FileManager
    private let fileName = "RaceHighscore.txt"
    private let terminator: String
    private let separator: String
    
    public init(terminator: String = "|", separator: String = ";") {
        self.fileManger = FileManager()
        self.separator = separator
        self.terminator = terminator
    }
    
    private func createFile(_ content: String) {
        fileManger.createFile(atPath: fileName, contents: content.data(using: .utf8))
    }
    
    private func isReadable() -> Bool {
        guard fileManger.fileExists(atPath: fileName) else {
            return false
        }
        
        guard let data = fileManger.contents(atPath: fileName), let data = String(data: data, encoding: .utf8),
              data.count > 1 else {
            return false
        }
        
        return true
    }
}

@available(macOS 12.0, *)
extension HigscoreTXTDataSource: DataSourceCreator {
    func create(new object: HigscoreData) throws {
        try create(name: object.name, score: object.score, date: object.date)
    }
    
    func create(name: String, score: Int, date: Date) throws {
        createNewFile()
        guard let data = String(data: fileManger.contents(atPath: fileName) ?? Data(), encoding: .utf8) else {
            return
        }
        
        createFile(data + "\(name)\(separator)\(score)\(separator)\(date.formatted())\(terminator)")
    }
    
    func createNewFile() {
        guard !fileManger.fileExists(atPath: fileName) else {
            return
        }
        
        createFile("name;score;date|")
    }
}

@available(macOS 12.0, *)
extension HigscoreTXTDataSource: DataSourceReader {
    func readAll() throws -> [HigscoreData] {
        guard isReadable() else {
            return [HigscoreData(name: "", score: 0, date: Date())]
        }
        
        let strings = String(data: fileManger.contents(atPath: fileName)!, encoding: .utf8)!.components(separatedBy: terminator)
        
        var res: [HigscoreData] = []
        for str in strings {
            let components = str.components(separatedBy: separator)
           
            guard components.count >= 3, let score = Int(components[1]) else {
                continue
            }
            
            let date = try Date(components[2], strategy: .dateTime)

            res.append(HigscoreData(name: components.first!, score: score, date: date))
        }
        
        return res
    }
    
    func read(where name: String) throws -> [HigscoreData] {
        return try readAll().filter { $0.name == name }
    }
    
    func read(top count: Int) throws -> [HigscoreData] {
        return try Array(readAll().sorted { $0.score > $1.score }.prefix(count))
    }
}

@available(macOS 12.0, *)
extension HigscoreTXTDataSource: DataSourceUpdater {
    func updateLast(with newScore: Int) throws {
        guard isReadable() else {
            return
        }
        
        var strings = String(data: fileManger.contents(atPath: fileName)!, encoding: .utf8)!.components(separatedBy: terminator)
        if let last = strings.last, last.count == 0 {
            strings = strings.dropLast()
        }
        
        guard let last = strings.last else {
            return
        }
        
        var lastComponents = last.components(separatedBy: separator)
        
        lastComponents[1] = "\(newScore)"
        
        strings[strings.count - 1] = lastComponents.joined(separator: separator)
        
        createFile(strings.joined(separator: terminator))
    }
    
    func updateLast(with newName: String) throws {
        guard isReadable() else {
            return
        }
        
        var strings = String(data: fileManger.contents(atPath: fileName)!, encoding: .utf8)!.components(separatedBy: terminator)
        if let last = strings.last, last.count == 0 {
            strings = strings.dropLast()
        }
        
        guard let last = strings.last else {
            return
        }
        
        var lastComponents = last.components(separatedBy: separator)
        
        lastComponents[0] = "\(newName)"
        
        strings[strings.count - 1] = lastComponents.joined(separator: separator)
        
        createFile(strings.joined(separator: terminator))
    }
}

@available(macOS 12.0, *)
extension HigscoreTXTDataSource: DataSourceDeleter {
    func deleteAll() throws {
        if isReadable() {
            fileManger.createFile(atPath: fileName, contents: Data())
        }
        createNewFile()
    }
    
    func delete(where name: String) throws {
        var data = try readAll()
        data.removeAll { $0.name == name }
        let strData = data.map { "\($0.name)\(separator)\($0.score)\(separator)\($0.date)\(terminator)"}
        createFile("name;score;date|" + strData.joined())
    }
    
    func delete(where score: Int) throws {
        var data = try readAll()
        data.removeAll { $0.score == score }
        let strData = data.map { "\($0.name)\(separator)\($0.score)\(separator)\($0.date)\(terminator)"}
        createFile("name;score;date|" + strData.joined())
    }
}
