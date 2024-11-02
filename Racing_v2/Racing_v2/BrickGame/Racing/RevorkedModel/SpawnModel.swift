//
//  SpawnModel.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 02.11.2024.
//

import Foundation

protocol EnemyCarSpawner {
    var racingModel: RacingModel? { get set }
    var enemyType: [EnemyRacingCar.Type] { get set }
    
    init(racingModel: RacingModel)
    
    func spawn()
}

class BaseEnemySpawner: EnemyCarSpawner {

    var racingModel: RacingModel?
    
    var enemyType: [any EnemyRacingCar.Type] = []
    
    required init(racingModel: RacingModel) {
        self.racingModel = racingModel
        enemyType.append(EnemyCar.self)
    }
    
    func spawn() {
        guard let racingModel = self.racingModel, racingModel.enemys.count < 3
                && racingModel.enemys.filter({ $0.yPos < 2 }).isEmpty
        else {
            return
        }
        
        if let newEnemy = spawnNext() {
            racingModel.enemys.append(newEnemy)
        } else if 10 > Int.random(in: 0...99) {
            let shift = Int.random(in: 0...1)
            racingModel.enemys.append(EnemyCar(xPos: 0 + shift))
            racingModel.enemys.append(EnemyCar(xPos: 6 + shift))
        }
        
        if racingModel.enemys.count == 0 {
            racingModel.enemys.append(enemyType[Int.random(in: 0..<enemyType.count)].init(xPos: RacingInt.random(in: 0...3), yPos: -6))
        }
    }
    
    private func spawnNext() -> EnemyRacingCar? {
        guard !enemyType.isEmpty else {
            return nil
        }
        
        let xPosition = Int.random(in: 0..<RacingDefines.xBorderSize - 3)
        
        guard xPosition % Int.random(in: 4...7) == 0 else {
            return nil
        }

        let selectedType = enemyType[Int.random(in: 0..<enemyType.count)]
             
        return selectedType.init(xPos: xPosition, yPos: -7)
    }
    
}    // BEnemySpawner
