import Vapor

func routes(_ app: Application) throws {
    let gameController = RacingController()
//    app.get { req throws -> String in
//        "It works!"
//    }
    
    app.get("game-info") { req async throws -> Response in
        return try gameController.updateState()
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.post("race-input") { req throws -> Response in
        return try gameController.userInput(req: req)
    }
    
    app.put("save-highscore") { req throws -> Response in
        return try SaveHighscoreController().saveAction(req: req)
    }
}
