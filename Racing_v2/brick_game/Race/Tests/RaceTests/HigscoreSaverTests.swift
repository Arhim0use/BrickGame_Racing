//
//  File.swift
//  Race
//
//  Created by Chingisbek Anvardinov on 18.12.2024.
//

import Testing
import XCTest
import Foundation

@testable import Race

class TXTHigscoreSaverUnitTest: HigscoreSaverUnitTest {
    
    override func setUpWithError() throws {
//        saver = TestSaver()
        dbHandler = BasicDataSourceHandler(dbHandler: HigscoreTXTDataSource())
        try dbHandler.deleteAll()
        try dbHandler.create(name: "testData", score: 111)
    }
    
    override func testChangeDataSource() throws {
        let prevHandler = dbHandler.dbHandler
        let nextHandler = TestSaver()
        dbHandler.switchDataSource(dataSource: nextHandler)
        
        let isEqual = type(of: prevHandler) == type(of: nextHandler)
        XCTAssertFalse(isEqual)
        XCTAssertTrue(type(of: nextHandler) == type(of: dbHandler.dbHandler))
    }
}

class RealmSaverUnitTest: XCTestCase {
    var dbHandler: BasicDataSourceHandler!
    var saver: (DataSourceCreator & DataSourceReader & DataSourceUpdater & DataSourceDeleter)!
    
    override func setUpWithError() throws {
//        saver = TestSaver()
        dbHandler = BasicDataSourceHandler(dbHandler: HighscoreRxRealmDataSource())
        try dbHandler.deleteAll()
        try dbHandler.create(name: "testData", score: 111)
    }
    
    func testChangeDataSource() throws {
        let prevHandler = dbHandler.dbHandler
        let nextHandler = TestSaver()
        dbHandler.switchDataSource(dataSource: nextHandler)
        
        let isEqual = type(of: prevHandler) == type(of: nextHandler)
        XCTAssertFalse(isEqual)
        XCTAssertTrue(type(of: nextHandler) == type(of: dbHandler.dbHandler))
    }
    
    func testRead_0() throws {
        let data = try dbHandler.readAll()
        
        XCTAssertEqual(data.count, 1)
        XCTAssertEqual(data.first!.name, "testData")
        XCTAssertEqual(data.first!.score, 111)
    }
}

class HigscoreSaverUnitTest: XCTestCase {
    var dbHandler: BasicDataSourceHandler!
    var saver: (DataSourceCreator & DataSourceReader & DataSourceUpdater & DataSourceDeleter)!
    
    override func setUpWithError() throws {
        saver = TestSaver()
        dbHandler = BasicDataSourceHandler(dbHandler: saver)
        try dbHandler.create(name: "testData", score: 111)
    }
    
    func testChangeDataSource() throws {
        let prevHandler = dbHandler.dbHandler
        let nextHandler = HigscoreTXTDataSource()
        dbHandler.switchDataSource(dataSource: nextHandler)
        
        let isEqual = type(of: prevHandler) == type(of: nextHandler)
        XCTAssertFalse(isEqual)
        XCTAssertTrue(type(of: nextHandler) == type(of: dbHandler.dbHandler))
    }
    
    func testRead_0() throws {
        let data = try dbHandler.readAll()
        
        XCTAssertEqual(data.count, 1)
    }
    
    func testRead_1() throws {
        let data = try dbHandler.readAll()
        
        XCTAssertEqual(data.first!.name, "testData")
        XCTAssertEqual(data.first!.score, 111)
    }
    
    func testCreate_0() throws {
        let obj = Race.HigscoreData(name: "Joe", score: 1, date: Date())

        try dbHandler.create(new: obj)
        
        let data = try dbHandler.readAll()
        XCTAssertEqual(data.count, 2)
//        XCTAssertEqual(data.last!.name, obj.name)
    }
    
    func testCreate_1() throws {
        let name = "Joe"
        try dbHandler.create(name: name, score: 1)
        
        let data = try dbHandler.readAll()
        XCTAssertEqual(data.count, 2)
        XCTAssertEqual(data.last!.name, name)
    }
    
    func testReadWithName_0() throws {
        let name = "Joe"
        
        let data = try dbHandler.read(where: name)
        XCTAssertEqual(data.count, 0)
    }
    
    func testReadWithName_1() throws {
        let name = "testData"
        
        let data = try dbHandler.read(where: name)
        XCTAssertEqual(data.count, 1)
    }
    
    func testReadTop_0() throws {
        let obj = Race.HigscoreData(name: "Joe", score: 1, date: Date())
        for _ in 0...4 {
            try dbHandler.create(new: obj)
        }
        
        let data = try dbHandler.read(top: 10)
        XCTAssertEqual(data.count, 6)
    }
    
    func testReadTop_1() throws {
        let obj = Race.HigscoreData(name: "Joe", score: 1, date: Date())
        for _ in 0...12 {
            try dbHandler.create(new: obj)
        }

        let data = try dbHandler.read(top: 10)
        XCTAssertEqual(data.count, 10)
    }
    
    func testReadTop_3() throws {
        var score = 1
        var obj = Race.HigscoreData(name: "Joe", score: score, date: Date())
        for _ in 0...12 {
            score = obj.score
            try dbHandler.create(new: obj)
            obj.score += 1
        }
        
        let top = 2
        let data = try dbHandler.read(top: top)
        
        XCTAssertEqual(data.count, top)
        XCTAssertEqual(data[data.count - top].score, 111)
        XCTAssertEqual(data[data.count - 1].score, score)
    }
    
    func testUpdateWithName_0() throws {
        let newName = "Smith"
        try dbHandler.updateLast(with: newName)

        let data = try dbHandler.read(top: 2)
        XCTAssertEqual(data.count, 1)
        XCTAssertEqual(data.last!.name, newName)
    }
    
    func testUpdateWithName_1() throws {
        try dbHandler.create(name: "Joe", score: 10)
        let newName = "Smith"
        try dbHandler.updateLast(with: newName)

        let data = try dbHandler.read(top: 2)
        XCTAssertEqual(data.count, 2)
        XCTAssertEqual(data.last!.name, newName)
        XCTAssertEqual(data.first!.name, "testData")
    }
    
    func testUpdateWithScore() throws {
        try dbHandler.create(name: "Joe", score: 10)
        let newScore = 20
        try dbHandler.updateLast(with: newScore)

        let data = try dbHandler.read(top: 2)
        XCTAssertEqual(data.count, 2)
        XCTAssertEqual(data.last!.score, newScore)
        XCTAssertEqual(data.first!.score, 111)
    }
    
    func testDeleteWhereName_0() throws {
        var score = 9
        for _ in 0..<3 {
            score += 1
            try dbHandler.create(name: "Joe", score: score)
        }
        
        try dbHandler.delete(where: "testData")
        
        let data = try dbHandler.readAll()
        XCTAssertEqual(data.count, 3)
    }
    
    func testDeleteWhereName_1() throws {
        for _ in 0..<3 {
            try dbHandler.create(name: "Joe", score: 10)
        }
        
        try dbHandler.delete(where: "Joe")
        
        let data = try dbHandler.readAll()
        XCTAssertEqual(data.count, 1)
    }
    
    func testDeleteWhereScore_0() throws {
        for _ in 0..<3 {
            try dbHandler.create(name: "Joe", score: 10)
        }
        
        try dbHandler.delete(where: 10)
        
        let data = try dbHandler.readAll()
        XCTAssertEqual(data.count, 1)
    }
    
    func testDeleteWhereScore_1() throws {
        for _ in 0..<3 {
            try dbHandler.create(name: "Joe", score: 10)
        }
        
        try dbHandler.delete(where: 111)
        
        let data = try dbHandler.readAll()
        XCTAssertEqual(data.count, 3)
    }
    
    func testHandleDecoderToIntArr_0() throws {
        var score = 9
        for _ in 0..<3 {
            score += 1
            try dbHandler.create(name: "1", score: score)
        }
        
        let data = try dbHandler.readAll()
        
        let scoreArr = BDHighscoreDecoder().toIntArr(of: data)
        
        XCTAssertEqual(scoreArr.last!, 11)
        XCTAssertEqual(scoreArr.first!, 111)
    }
    
    func testHandleDecoderToIntArr_1() throws {
        var score = 9
        for _ in 0..<3 {
            score += 1
            try dbHandler.create(name: "1", score: score)
        }
        
        let data = try dbHandler.readAll()
        
        let scoreArr = BDHighscoreDecoder().toIntArr(top: 5, of: data)
        
        XCTAssertEqual(scoreArr.last!, 10)
        XCTAssertEqual(scoreArr.first!, 111)
    }
    
    func testHandleDecoderToStr_0() throws {
        let data = try dbHandler.readAll()
        
        let str = BDHighscoreDecoder().toStr(top: 1, of: data)
        
        XCTAssertEqual(str, "testData;111;\(Date().formatted())")
    }
    
    func testDeleteAll() throws {
        for _ in 0..<3 {
            try dbHandler.create(name: "Joe", score: 10)
        }
        
        try dbHandler.deleteAll()
        
        let data = try dbHandler.readAll()
        XCTAssertEqual(data.count, 1)
    }
}



class TestSaver: DataSourceCreator, DataSourceReader, DataSourceUpdater, DataSourceDeleter {
    var data = ""
    
    func create(new object: Race.HigscoreData) throws {
        try create(name: object.name, score: object.score, date: object.date)
    }
    
    func create(name: String, score: Int, date: Date) throws {
        data += name + "|" + String(score) + "|" + date.formatted() + ";"
    }
    
    func readAll() throws -> [Race.HigscoreData] {
        guard !data.isEmpty else {
            return [HigscoreData(name: "", score: 0, date: Date())]
        }
        
        let separated = data.components(separatedBy: ";")
        var res: [Race.HigscoreData] = []
        for component in separated where component.count > 0 {
            let c = component.components(separatedBy: "|")
            
            let date = try Date(c[2], strategy: .dateTime)
            res.append(HigscoreData(name: c[0], score: Int(c[1]) ?? 0, date: date))
        }
        return res
    }
    
    func read(where name: String) throws -> [Race.HigscoreData] {
        return Array(try readAll().filter { $0.name == name } )
    }
    
    func read(top count: Int) throws -> [Race.HigscoreData] {
        let res = try readAll().sorted { $0.score < $1.score }
        return Array(res.suffix(count)).reversed()
    }
    
    func updateLast(with newScore: Int) throws {
        var all = data.components(separatedBy: ";")
        if let last = all.last, last.count == 0 {
            all = all.dropLast()
        }
        
        guard var last = all.last else { return }
        
        var l = last.components(separatedBy: "|")
        
        l[1] = String(newScore)
        
        last = l[0] + "|" + l[1] + "|" + l[2]
        all[all.count - 1] = last
        data = all.joined(separator: ";")
    }
    
    func updateLast(with newName: String) throws {
        var all = data.components(separatedBy: ";")
        if let last = all.last, last.count == 0 {
            all = all.dropLast()
        }
        
        guard var last = all.last else { return }
        
        var l = last.components(separatedBy: "|")
        
        l[0] = newName
        
        last = l[0] + "|" + l[1] + "|" + l[2]
        all[all.count - 1] = last
        data = all.joined(separator: ";")
    }
    
    func deleteAll() throws {
        data = ""
    }
    
    func delete(where name: String) throws {
        let separeted = data.components(separatedBy: ";")
        try deleteAll()
        
        for component in separeted {
            if !component.contains(name) {
                data += component + ";"
            }
        }
    }
    
    func delete(where score: Int) throws {
        let separeted = data.components(separatedBy: ";")
        try deleteAll()
        
        for component in separeted {
            if !component.contains("\(score)") {
                data += component + ";"
            }
        }
    }
}
