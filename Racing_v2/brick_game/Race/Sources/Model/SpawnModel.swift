//
//  SpawnModel.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 23.10.2024.
//

import Foundation

protocol Spawner {
    func spawn()
}

protocol EnemyCarSpawner: Spawner {
    var racingModel: RacingModel { get set }
    var enemyType: [EnemyRacingCar.Type] { get set }
    
    init(racingModel: RacingModel)
}

class BaseEnemySpawner: EnemyCarSpawner {

    var racingModel: RacingModel
    
    var enemyType: [EnemyRacingCar.Type] = []
    
    var maxEnemyCount = 5
    var minOffset = 3
    var doubleCarChanse: UInt8 = 10
    
    required init(racingModel: RacingModel) {
        self.racingModel = racingModel
        enemyType.append(EnemyCar.self)
    }
    
    func spawn() {
        guard racingModel.enemys.count < maxEnemyCount
                && racingModel.enemys.filter({ $0.yPos < minOffset }).isEmpty
        else {
            return
        }
        
        spawnLogic()
    }
    
    func spawnLogic() {

    }
    
    
    fileprivate func doubleCar(_ shift: Int) {
        racingModel.enemys.append(EnemyCar(xPos: 0 + shift, yPos: -7 + Int.random(in: 0...1)))
        racingModel.enemys.append(EnemyCar(xPos: 6 + shift, yPos: -7 + Int.random(in: 0...1)))
    }

}    // BaseEnemySpawner

class ClassicEnemySpawner: BaseEnemySpawner {

    override func spawnLogic() {
        if doubleCarChanse > Int.random(in: 0...99) {
            let shift = Int.random(in: 0...1)
            doubleCar(shift)
        } else if let newEnemy = spawnNext() {
            racingModel.enemys.append(newEnemy)
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
}

class RandomSideSpawner: BaseEnemySpawner {
    var onLeft = Bool.random()

    override func spawnLogic() {
        let side = onLeft ? 0 : 5
        
        let shift = Int.random(in: 0...1)
        if doubleCarChanse > Int.random(in: 0...99) {
            doubleCar(shift)
        } else {
         racingModel.enemys.append(EnemyCar(xPos: side + shift))
        }
    }
}

