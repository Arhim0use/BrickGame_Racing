//
//  SaveHighscore.swift
//  BrickGameServ
//
//  Created by Chingisbek Anvardinov on 11.12.2024.
//

import Foundation
import Vapor

import Race

struct SaveRequest: Content {
    let name: String
}

final class SaveHighscoreController {
    let dbHandler = BasicDataSourceHandler()
    
    fileprivate func check(name: String) -> Bool {
        guard name.count < 11 else {
            return false
        }
        
        var flag = false
        for char in name {
            if char != " " {
                flag = true
            }
        }
        return flag
    }
    
    func saveAction(req: Request) throws -> Response {
        let input = try req.content.decode(SaveRequest.self)
        
        guard check(name: input.name) else {
            return Response(status: .badRequest, body: .init(string: "Invalid name, please try again."))
        }
        
        try dbHandler.updateLast(with: input.name)
//        try dbHandler.delete(where: "")
         
        return Response(status: .ok, body: .empty)
    }
}
