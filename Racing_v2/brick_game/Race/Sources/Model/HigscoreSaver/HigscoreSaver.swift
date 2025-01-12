//
//  HigscoreSaver.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 11.11.2024.
//

import Foundation

public struct HigscoreData: Codable {
    public var name: String
    public var score: Int
    public var date: Date
    
    public init(name: String, score: Int, date: Date) {
        self.name = name
        self.score = score
        self.date = date
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.score = try container.decode(Int.self, forKey: .score)
        self.date = try container.decode(Date.self, forKey: .date)
    }
}

public protocol DataSourceCreator {
    func create(new object: HigscoreData) throws
    func create(name: String, score: Int, date: Date) throws
}

public protocol DataSourceReader {
    func readAll() throws -> [HigscoreData]
    func read(where name: String) throws -> [HigscoreData]
    func read(top count: Int) throws -> [HigscoreData]
}

public protocol DataSourceUpdater {
    func updateLast(with newScore: Int) throws
    func updateLast(with newName: String) throws
}

public protocol DataSourceDeleter {
    func deleteAll() throws
    func delete(where name: String) throws
    func delete(where score: Int) throws
}

@available(macOS 12.0, *)
public class BasicDataSourceHandler {
    private(set) var dbHandler: (DataSourceCreator & DataSourceReader & DataSourceUpdater & DataSourceDeleter)
    
    public init() {
        self.dbHandler = HigscoreTXTDataSource()

        #if os(macOS)
            self.dbHandler = HighscoreRxRealmDataSource()
        #endif
    }
    
    public init(dbHandler: DataSourceCreator & DataSourceReader & DataSourceUpdater & DataSourceDeleter) {
        self.dbHandler = dbHandler
    }
    
    public func switchDataSource(dataSource: DataSourceCreator & DataSourceReader & DataSourceUpdater & DataSourceDeleter) {
        self.dbHandler = dataSource
    }
    
    public func create(new object: HigscoreData) throws {
        try dbHandler.create(name: object.name, score: object.score, date: object.date)
    }
    
    public func create(name: String, score: Int, date: Date = Date()) throws {
        try dbHandler.create(name: name, score: score, date: date)
    }
    
    public func readAll() throws -> [HigscoreData] {
        return try dbHandler.readAll()
    }
    
    public func read(where name: String) throws -> [HigscoreData] {
        return try dbHandler.read(where: name)
    }
    
    public func read(top count: Int) throws -> [HigscoreData] {
        return try dbHandler.read(top: count)
    }
    
    public func updateLast(with newScore: Int) throws {
        try dbHandler.updateLast(with: newScore)
    }
    
    public func updateLast(with newName: String) throws {
        try dbHandler.updateLast(with: newName)
    }
    
    public func deleteAll() throws {
        try dbHandler.deleteAll()
    }
    
    public func delete(where name: String) throws {
        try dbHandler.delete(where: name)
    }
    
    public func delete(where score: Int) throws {
        try dbHandler.delete(where: score)
    }
} // BasicDataSourceHandler

@available(macOS 12.0, *)
public class BDHighscoreDecoder {
    
    public init() { }
    
    /// - Returns: sorted top of  person scores with name
    public func toStr(top maxLengh: UInt32 = 3, of data: [HigscoreData], terminator: String = "\n", separator: String = ";") -> String {
        let sorted = data.sorted { $0.score > $1.score }
        
        return get(top: maxLengh, of: sorted).map { person in
            return "\(person.name)\(separator)\(person.score)\(separator)\(person.date.formatted())"
        }.joined(separator: terminator)
    }
    
    /// - Returns: sorted top of  person scores
    func toIntArr(top maxLengh: UInt32 = 3, of data: [HigscoreData]) -> [Int] {
        let sorted = data.sorted { $0.score > $1.score }

        return Array(get(top: maxLengh, of: sorted).map { $0.score })
    }
    
    private func get(top maxLengh: UInt32 = 3, of data: [HigscoreData]) -> [HigscoreData] {
        return Array(data.prefix(Int(maxLengh)))
    }
}

