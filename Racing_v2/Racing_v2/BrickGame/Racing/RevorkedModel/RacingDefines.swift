//
//  Defines.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 05.10.2024.
//

import Foundation

typealias RacingInt = Int

struct RacingDefines {
    
    static let maxLevel: RacingInt = 10
    static let toNextLvl: RacingInt = 19

    static let xBorderSize: RacingInt = 10
    static let yBorderSize: RacingInt = 20
    
    static var xStartPos: RacingInt { get { xBorderSize / 2 - 1 } }
    static var yStartPos: RacingInt { get { yBorderSize / 2 - 1 } }
    
    static let speedArr: [Int32] = [110, 100, 90, 81, 72, 63, 55, 47, 39, 32, 28]
    static let startSpeed = RacingDefines.speedArr[0]
    
    static let startLiveCount = 3
    static let immortalFrames = 9
}
