//
//  RacingLogic.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 02.11.2024.
//

import Foundation


class RacingLogic {
    private var _collisionHandler: PREV_CollisionCheckable
    private var _lvlManager: PREV_LevelManager
    private var _racingFSM: FinalStateMachine
    private var _spawner: EnemySpawner
    private var _racingModel: RacingModel
//    private var _moveHandler: MoveHandler
    
    var collisionHandeler: PREV_CollisionCheckable {
        get { self._collisionHandler }
        //        set {
        //            variable name = newValue
        //        }
    }
    
    var lvlManager: PREV_LevelManager {
        get { self._lvlManager }
    }
    
    var racingFSM: FinalStateMachine {
        get { self._racingFSM }
    }
    
    var spawner: EnemySpawner {
        get { self._spawner }
    }
    
    var racingModel: RacingModel {
        get { self._racingModel }
    }
    
//    var moveHandler: MoveHandler {
//        get { self._moveHandler }
//    }
    
    /// - Note: **Заглушка**
    init(_collisionHandler: PREV_CollisionCheckable, _lvlManager: PREV_LevelManager, _racingFSM: FinalStateMachine, _spawner: EnemySpawner, _racingModel: RacingModel) {
       
        self._racingModel = _racingModel
        self._collisionHandler = _collisionHandler
        self._lvlManager = _lvlManager
        self._racingFSM = _racingFSM
        self._spawner = _spawner
    }
    
    
}
