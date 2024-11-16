//
//  main.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 02.11.2024.
//

import Foundation

fileprivate var loop = 0
fileprivate let input: UserAction? = nil
fileprivate var cInput: Action? = Action( UInt32.random(in: 3...7))

fileprivate func moveEnemys(_ model: RacingModel) {
    for var enemy in model.enemys {
        enemy.yPos += 1
    }
}

fileprivate func countedCikle(loops: Int, doSomthing: () -> ()) {
    while loop < loops {
        doSomthing()
        loop += 1
    }
}

print("Hello, World!")

//do {
//    let viewModel = RacingViewModel()
//    viewModel.startGame()
//    while viewModel.currentState != .end && loop < 1 {
//        viewModel.updateGame(with: input)
//        print("loop:", loop)
//        loop += 1
//    }
//}

//do {
//    let model = RacingModel()
//    let spawner = RightSideSpawner(racingModel: model)
//    
//    while loop < 50 {
//        spawner.spawn()
//        loop += 1
//        moveEnemys(model)
//        model.placeObjectOnField()
//        model.gameInfoWrapper.printField()
//    }
//}

//do {
//    let model = RacingModel()
//    let fsm = RacingStateMachine(gameModel: model)
//    fsm.spawner = BaseEnemySpawner(racingModel: model)
//    fsm.collisionHandler = CollisionHandler(racingModel: model)
//    fsm.start()
//    
//    countedCikle(loops: 90) {
//        if fsm.currentState != .end {
//            fsm.gameLoop(input)
//            if loop % 3 == 0 {
//                print("loop", loop)
//            }
//        }
//    }
//    
//}


//do {
//    let viewModel = RacingViewModel()
//    viewModel.startGame()
//    while viewModel.gameState != .end && loop < 4 {
//        if loop <= 2 {
//            cInput = Action(UInt32.random(in: 3...7))
//        } else {
//            cInput = nil
//        }
//        viewModel.userInput(with: cInput)
//        viewModel.model.gameInfoWrapper.printField()
//        print("state", viewModel.fsm.currentState)
//        //        if let f = viewModel.model.enemys.first {
//        //            print("enemys.first", f.yPos)
//        //        }
//        print("lastInput", BrickGameStateMachine.lastInput ?? "nil")
////        print("level", viewModel.model.level)
////        print("score", viewModel.model.score)
//        
//        
//        loop += 1
// 
//    }
//    viewModel.endGame()
//}

do {
    let viewModel = RacingViewModel()
    viewModel.userInput(with: Start)
    
    while viewModel.currentState != .end && loop < 1000 {
        if loop <= 2 {
            cInput = Action(UInt32.random(in: 3...7))
        } else {
            cInput = nil
        }
        viewModel.userInput(with: nil)
        if let f = viewModel.model.enemys.first {
            print(f.yPos)
        }
//        print(viewModel.model.player.xPos)
        loop += 1
    }
}
