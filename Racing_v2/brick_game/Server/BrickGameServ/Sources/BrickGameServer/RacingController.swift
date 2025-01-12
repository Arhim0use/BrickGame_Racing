//
//  RacingController.swift
//  BrickGameServ
//
//  Created by Chingisbek Anvardinov on 29.11.2024.
//

import Foundation

import Vapor

import Race
import CommonBrickGame


struct InputRequest: Content {
    let rawValue: String
}

struct GameInfo: Codable {
    var field: [[Int32]]
    let score: Int32
    let high_score: Int32
    let level: Int32
    let speed: Int32
    let pause: Int32
    let lives: Int32
    
    public init(cStruct: GameInfo_t, lives: Int32) {
        self.high_score = cStruct.high_score
        self.score = cStruct.score
        self.level = cStruct.level
        self.speed = cStruct.speed
        self.pause = cStruct.pause
        self.lives = lives
        
        self.field = []
        if let fieldPointer = cStruct.field {
            for i in 0..<RacingDefines.yBorderSize {
                let rowPointer = fieldPointer[i]
                var row: [Int32] = []
                for j in 0..<RacingDefines.xBorderSize {
                    row.append(Int32(rowPointer?[j] ?? 0))
                }
                self.field.append(row)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case field
        case score
        case high_score
        case level
        case speed
        case pause
        case lives
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.field, forKey: .field)
        try container.encode(self.score, forKey: .score)
        try container.encode(self.high_score, forKey: .high_score)
        try container.encode(self.level, forKey: .level)
        try container.encode(self.speed, forKey: .speed)
        try container.encode(self.pause, forKey: .pause)
        try container.encode(self.lives, forKey: .lives)
    }
}


final class RacingController {
    private let viewModel = RacingViewModel()
    
    fileprivate func getAction(from input: InputRequest) -> Action? {
        var action: Action?
        switch input.rawValue {
        case "KeyS":
            action = Start
        case "KeyP":
            action = Pause
        case "KeyQ":
            action = Terminate
        case "ArrowUp":
            action = Up
        case "ArrowLeft":
            action = Left
        case "ArrowRight":
            action = Right
        case "ArrowDown":
            action = Down
        default:
            action = nil
        }
        
        return action
    }
    
    func userInput(req: Request) throws -> Response {
        let input = try req.content.decode(InputRequest.self)
        
        viewModel.userInput(with: getAction(from: input))
        
        let gameInfo = (viewModel.updateCurrentState(), Int32(viewModel.lives))
//        print(req.body.string)
        return Response(status: .ok, body: .init(data: try JSONEncoder().encode(GameInfo(cStruct: gameInfo.0, lives: gameInfo.1))))
    }
    
    func updateState() throws -> Response {
        let gameInfo = GameInfo(cStruct: viewModel.updateCurrentState(), lives: Int32(viewModel.lives))
        
        let response = Response(status: .ok, body: .init(data: try JSONEncoder().encode(gameInfo)))
        
        return response
    }
}
