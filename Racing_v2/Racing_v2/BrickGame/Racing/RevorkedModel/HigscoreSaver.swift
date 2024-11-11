//
//  HigscoreSaver.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 11.11.2024.
//

import Foundation

import RealmSwift

class PersonHigscore: Object, Identifiable {
    @Persisted(primaryKey: true) var id = UUID()
    @Persisted var name = ""
    @Persisted var score = 0
    @Persisted var date = Date.now
    
    convenience init(name: String = "", score: Int = 0) {
        self.init()
        self.name = name
        self.score = score
        self.id = UUID()
        self.date = Date.now
    }
}

class BrickGameDataSource {
    private let realm: Realm
    
    init() throws {
        self.realm = try Realm()
//        print("data storage path:", realm.configuration.fileURL?.path() ?? "err")
    }
    
    func create(new object: Object) throws {
        try realm.write {
            realm.add(object)
        }
    }
    
    func readAll() -> Results<PersonHigscore> {
        return realm.objects(PersonHigscore.self)
    }
    
    func read(where property: Any) -> Results<PersonHigscore> {
        let all = readAll()
        return all.where { $0.name == property as? String ?? "" }
    }
    
    func deleteAll() throws {
        try realm.write {
          realm.deleteAll()
        }
    }
}

protocol DataExchangebel {
    func create(name: String, score: Int32)
    func readAll() -> String
    func read(where name: String) -> String
    func deleteAll()
}

class BDHigscoreDecoder: DataExchangebel {
    private let realmDS: BrickGameDataSource
    
    init() throws {
        self.realmDS = try BrickGameDataSource()
    }
    
    func create(name: String, score: Int32) {
        do {
            try realmDS.create(new: PersonHigscore(name: name, score: Int(score)))
        } catch { }
    }
    
    private func convertToStr(_ data: Results<PersonHigscore>, _ maxLengh: Int) -> String {
        return data.prefix(maxLengh).map { person in
            return "\(person.name) \(person.score)"
        }.joined(separator: "\n")
    }
    
    func readAll() -> String {
        let data = realmDS.readAll().sorted(by: \PersonHigscore.score, ascending: false)
        
        return convertToStr(data, 3)
    }
    
    func read(where name: String) -> String {
        let data = realmDS.read(where: name).sorted(by: \PersonHigscore.score, ascending: false)
        
        return convertToStr(data, 3)
    }
    
    func deleteAll() {
        do {
            try realmDS.deleteAll()
        } catch { }
    }
}

