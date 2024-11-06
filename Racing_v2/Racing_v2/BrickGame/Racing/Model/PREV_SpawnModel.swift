////
////  SpawnModel.swift
////  AP2_BrickGame3_Swift
////
////  Created by Chingisbek Anvardinov on 23.10.2024.
////
//
//import Foundation
//
//protocol PREV_EnemySpawner {
//    var racingModel: PREV_RacingModel? { get set }
//    var enemyType: [EnemyRacingCar.Type] { get set }
//    
//    init()
//    
//    func spawnNext()
//    func spawn() -> Any?
//}
//
//class BasicEnemySpawner : PREV_EnemySpawner {
//    weak var racingModel: PREV_RacingModel? = nil
//    var enemyType: [EnemyRacingCar.Type] = []
//    
//    required init() {
//        self.enemyType = [EnemyCar.self, SmallEnemy.self]
//        self.racingModel = nil
//    }
//    
//    deinit {
//        print("🛑 BasicEnemySpawner deinit ")
//    }
//    
//    /// - Note: add more spawn types
//    func registerEnemyType(_ type: EnemyRacingCar.Type) {
//        enemyType.append(type)
//    }
//    
//    /// - Note: add next object on field
//    func spawnNext() {
//        guard let model = self.racingModel else {
//            return
//        }
//        
//        guard model.enemys.count < 3
//                && model.enemys.filter({ $0.yPos < 2 }).isEmpty
//        else {
//            return
//        }
//        
//        if let newEnemy = spawn(), let newEnemy = newEnemy as? EnemyRacingCar {
//            model.enemys.append(newEnemy)
//        } else if 10 > Int.random(in: 0...99) {
//            let shift = Int.random(in: 0...1)
//            model.enemys.append(EnemyCar(xPos: 0 + shift))
//            model.enemys.append(EnemyCar(xPos: 6 + shift))
//        }
//        
//        if model.enemys.count == 0 {
//            model.enemys.append(enemyType[Int.random(in: 0..<enemyType.count)].init(xPos: RacingInt.random(in: 0...3), yPos: -6))
//        }
//    }
//    
//    /// - returns: Some new object, this implimentation depends on
//    /// internal var enemyType: [EnemyRacingCar.Type]
//    /// and random of size object type
//    func spawn() -> Any? {
//        let pos = Int.random(in: 0..<RacingDefines.xBorderSize - 3)
//        guard pos % Int.random(in: 4...7) == 0 else {
//            return nil
//        }
//        
//        guard !enemyType.isEmpty else {
//            return nil
//        }
//         
//        let selectedType = enemyType[Int.random(in: 0..<enemyType.count)]
//             
//        return selectedType.init(xPos: pos, yPos: -7)
//    }
//}  // class DefoultEnemySpawner
//
///// - Note: create new object just on left side of field
//class LeftEnemySpawner : BasicEnemySpawner {
//     deinit {
//        print("🛑 LeftEnemySpawner deinit ")
//    }
//    
//    override func spawnNext() {
//        guard let model = self.racingModel else {
//            return
//        }
//        
//        guard model.enemys.filter({ $0.yPos < 2 }).isEmpty
//        else {
//            return
//        }
//        
//        let shift = Int.random(in: 0...1)
//
//        if Int.random(in: 0...1) == 1 {
//            model.enemys.append(EnemyCar(xPos: 0 + shift))
//        } else if 10 > Int.random(in: 0...99) {
//            model.enemys.append(EnemyCar(xPos: 0 + shift))
//            model.enemys.append(EnemyCar(xPos: 6 + shift))
//        }
//    }
//    
//}  // class LeftEnemySpawner
//
///// - Note: create new object just on right side of field
//class RightEnemySpawner : BasicEnemySpawner {
//    
//     deinit {
//         print("🛑 RightEnemySpawner deinit ")
//    }
//    
//    override func spawnNext() {
//        guard let model = self.racingModel else {
//            return
//        }
//        
//        guard model.enemys.filter({ $0.yPos < 2 }).isEmpty else {
//            return
//        }
//        
//        let shift = Int.random(in: 0...1)
//
//        if Int.random(in: 0...1) == 1 {
//            model.enemys.append(EnemyCar(xPos: RacingDefines.xBorderSize / 2 + shift))
//        }
//    }
//    
//}  // class RightEnemySpawner
//
///// - Note: create various obstacles on field
///// ```
///// // example
///// |1234567890|
///// |          |
///// |          |
///// |    ---   |
///// |          |
///// |    🁢     |
///// |   🁢🁢🁢    |
///// |    🁢     |
///// |---🁢🁢🁢 ---|
///// ```
//class GeometricEnemySpawner : BasicEnemySpawner {
//    
//     deinit {
//         print("🛑 GeometricEnemySpawner deinit ")
//    }
//    
//    override func spawnNext() {
//        guard let model = self.racingModel else {
//            return
//        }
//        
//        guard model.enemys.filter({ $0.yPos < 4 }).isEmpty else {
//            return
//        }
//        
//        
//        let left = Bool.random()
//        var newEnemy: [EnemyRacingCar]
//        switch Int.random(in: 0...2) {
//        case 0:
//            newEnemy = diagonalWall(fromLeft: left)
//        case 1:
//            newEnemy = tunnels(fromLeft: left)
//        default:
//            newEnemy = blockOnRoad(fromLeft: left)
//        }
//        
//        model.enemys = model.enemys + newEnemy
////        if let x = model.enemys.first {
////            print("📢", #function, x, x.yPos, model.enemys.last?.xPos)
////        }
//    }
//    
//    private func diagonalWall(fromLeft: Bool) -> [EnemyRacingCar] {
//        var wall: [EnemyRacingCar] = []
//
//        let halfWidth = RacingDefines.xBorderSize / 2
//
//        if fromLeft {
//            for i in 0..<halfWidth {
//                wall.append(DotEnemy(xPos: i, yPos: -i))
//                wall.append(DotEnemy(xPos: halfWidth - i, yPos: -halfWidth - i))
//            }
//        } else {
//            for i in 0..<halfWidth {
//                wall.append(DotEnemy(xPos: RacingDefines.xBorderSize - 1 - i, yPos: -i))
//                wall.append(DotEnemy(xPos: RacingDefines.xBorderSize - halfWidth + i - 1, yPos: -halfWidth - i))
//            }
//        }
//        
////        print("🛑 \(#function) \(fromLeft) \(wall.count)")
//
//        return wall
//    }
//    
//    private func tunnels(fromLeft: Bool) -> [EnemyRacingCar] {
//        var tunnel: [EnemyRacingCar] = []
//        
//        let offset = fromLeft ? -6 : 0
//
//        for i in 0..<(RacingDefines.xBorderSize / 2 - 1) {
//            let xPos = fromLeft ? offset + i : offset - i
//            tunnel.append(DoorEnemy(xPos: xPos, yPos: -4 * i - 4))
//        }
//        
////        print("🛑 \(#function) \(fromLeft) \(tunnel.count)")
//        return tunnel
//    }
//    
//    private func blockOnRoad(fromLeft: Bool) -> [EnemyRacingCar] {
//        let offset = fromLeft ? 0 : 1
////        print("🛑 \(#function) \(fromLeft)")
//        
//        return [BlockEnemy(xPos: 0, yPos: -2), BlockEnemy(xPos: 6, yPos: -2), BlockEnemy(xPos: 2 + offset, yPos: -2 - 7)]
//    }
//    
//}  // class GeometricEnemySpawner
