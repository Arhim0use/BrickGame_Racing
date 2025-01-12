//
//  RxRealmDataSource.swift
//  Racing
//
//  Created by Chingisbek Anvardinov on 09.12.2024.
//

import Foundation

import RealmSwift
import RxRealm
import RxSwift

public class PersonHighscore: Object, Identifiable {
    @Persisted(primaryKey: true) public var id = UUID()
    @Persisted public var name = ""
    @Persisted public var score = 0
    @Persisted public var date = Date()

    convenience init(name: String = "", score: Int = 0, date: Date = Date()) {
        self.init()
        self.name = name
        self.score = score
        self.id = UUID()
        self.date = date
    }
}

class HighscoreRxRealmDataSource {
    let disposeBag: DisposeBag

    public init() {
        self.disposeBag = DisposeBag()
    }

    private func realmReadAll() throws -> Results<PersonHighscore> {
        let realm = try Realm()
        return realm.objects(PersonHighscore.self)
    }

    private func rxRealmReadAll() throws -> Observable<Results<PersonHighscore>> {
//        let realm = try Realm()
//        Observable.fr
        return Observable.collection(from: try realmReadAll())
    }
}

extension HighscoreRxRealmDataSource: DataSourceCreator {
    func create(name: String = "", score: Int = 0, date: Date = Date()) throws {
        let realm = try Realm()
        try realm.write {
            realm.add(PersonHighscore(name: name,
                                      score: score,
                                      date: date))
        }
    }

    func create(new object: HigscoreData) throws {
        let realm = try Realm()
        try realm.write {
            realm.add(PersonHighscore(name: object.name,
                                      score: object.score,
                                      date: object.date))
        }
    }
}

extension HighscoreRxRealmDataSource: DataSourceReader {
    func readAll() throws -> [HigscoreData] {
        let data = try realmReadAll().map {
            HigscoreData(name: $0.name, score: $0.score, date: $0.date)
        }
        
        guard !data.isEmpty else {
            return [HigscoreData(name: "", score: 0, date: Date())]
        }
        
//        let res = Array(data)
        
        return Array(data)
    }

    func read(where name: String) throws -> [HigscoreData] {
        let data = try realmReadAll()
            .filter({ $0.name == name })
            .map { HigscoreData(name: $0.name, score: $0.score, date: $0.date) }

        return Array(data)
    }

    func read(top count: Int) throws -> [HigscoreData] {
        let data = try realmReadAll()
            .sorted(by: \PersonHighscore.score, ascending: false)
            .map { HigscoreData(name: $0.name, score: $0.score, date: $0.date) }

        return Array(data)
    }
}

extension HighscoreRxRealmDataSource: DataSourceUpdater {
    func updateLast(with newScore: Int) throws {
        guard let last = try realmReadAll().last else {
            fatalError("Can't fint last data sourse")
        }
        let realm = try Realm()

        Observable.just(last).subscribe(onNext: { toUpdate in
            do {
                try realm.write {
                    toUpdate.score = newScore
                }
            } catch {
                print(error)
            }
        })
        .disposed(by: disposeBag)
    }

    func updateLast(with newName: String) throws {
        guard let last = try realmReadAll().last else {
            fatalError("Can't fint last data sourse")
        }
        let realm = try Realm()

        Observable.just(last).subscribe(onNext: { toUpdate in
            do {
                try realm.write {
                    toUpdate.name = newName
                }
            } catch {
                print(error)
            }
        })
        .disposed(by: disposeBag)
    }
}

extension HighscoreRxRealmDataSource: DataSourceDeleter {
    func deleteAll() throws {
//        let realm = try Realm()
        guard try !Realm().isEmpty else { return }
        let data = try rxRealmReadAll()

        data.subscribe(try Realm().rx.delete())
            .disposed(by: disposeBag)
    }

    func delete(where name: String) throws {

        guard try !Realm().isEmpty else { return }

        let data = try realmReadAll().where { $0.name == name }

        Observable.collection(from: data)
            .subscribe(try Realm().rx.delete())
            .disposed(by: disposeBag)
    }

    func delete(where score: Int) throws {
//        let realm = try Realm()
        guard try !Realm().isEmpty else { return }

        let data = try realmReadAll().where { $0.score == score }

        Observable.collection(from: data)
            .subscribe(try Realm().rx.delete())
            .disposed(by: disposeBag)
    }
}
