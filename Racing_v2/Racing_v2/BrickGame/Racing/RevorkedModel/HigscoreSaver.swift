//
//  HigscoreSaver.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 11.11.2024.
//

import Foundation

import RealmSwift

class PersonHighscore: Object, Identifiable {
    @Persisted(primaryKey: true) var id = UUID()
    @Persisted var name = ""
    @Persisted var score = 0
    @Persisted var date = Date()
    
    convenience init(name: String = "", score: Int = 0) {
        self.init()
        self.name = name
        self.score = score
        self.id = UUID()
        self.date = Date()
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
    
    func readAll() -> Results<PersonHighscore> {
        return realm.objects(PersonHighscore.self)
    }
    
    func read(where property: Any) -> Results<PersonHighscore> {
        let all = readAll()
        return all.where { $0.name == property as? String ?? "" }
    }
    
    func updateLast(with newScore: Int) throws {
        let scores = readAll()
        if let toUpdate = scores.last {
            try realm.write {
                toUpdate.score = newScore
//                toUpdate.date = Date.now
            }
        }
    }
    
    func updateLast(with newName: String) throws {
        let scores = readAll()
        if let toUpdate = scores.last {
            try realm.write {
                toUpdate.name = newName
            }
        }
    }
    
    func deleteAll() throws {
        try realm.write {
          realm.deleteAll()
        }
    }
}

class BDHighscoreDecoder {
    static var maxTop: UInt32 = 3
    
    /// - Returns: sorted top of  person scores with name
    func toStr(top maxLengh: UInt32 = maxTop, of data: Results<PersonHighscore>, delimeter: String = "\n ") -> String {
        let sorted = data.sorted(by: \PersonHighscore.score, ascending: false)
        
        return get(top: maxLengh, of: sorted).map { person in
            return "\(person.name) \(person.score)"
        }.joined(separator: delimeter)
    }
    
    /// - Returns: sorted top of  person scores
    func toIntArr(top maxLengh: UInt32 = maxTop, of data: Results<PersonHighscore>) -> [Int] {
        let sorted = data.sorted(by: \PersonHighscore.score, ascending: false)

        let res = get(top: maxLengh, of: sorted).map { $0.score }
        return Array(res)
    }
    
    private func get(top maxLengh: UInt32 = maxTop, of data: Results<PersonHighscore>) -> Slice<Results<PersonHighscore>> {
        return data.prefix(Int(maxLengh))
    }
}
