//
//  CollisionsTests.swift
//  Racing
//
//  Created by Chingisbek Anvardinov on 13.12.2024.
//

import Testing
import XCTest

@testable import Race

class CollisionUnitTest: XCTestCase {
    let model = RacingModel()
    var collisionHandler:CollisionHandler?
    
    override func setUpWithError() throws {
        model.enemys = [EnemyCar(xPos: 0, yPos: 0)]
        self.collisionHandler = CollisionHandler(racingModel: model)
    }

    func testDoesntIntersectIsFar() throws {
        model.player.xPos = 0

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectTopSide() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 10

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectTopLeft() throws {
        model.player.xPos = 1
        model.enemys[0].yPos = 11

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectMidLeft() throws {
        model.player.xPos = 2
        model.enemys[0].yPos = 14

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectDownLeft_0() throws {
        model.player.xPos = 2
        model.enemys[0].yPos = 16

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectDownLeft_1() throws {
        model.player.xPos = 2
        model.enemys[0].yPos = 18

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectTopRight() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 11
        model.enemys[0].xPos = 2

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectMidRight() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 14
        model.enemys[0].xPos = 2

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectDownRight_0() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 16
        model.enemys[0].xPos = 2

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectDownRight_1() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 18
        model.enemys[0].xPos = 2

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectDown_0() throws {
        model.player.xPos = 1
        model.enemys[0].yPos = 19

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectDown_1() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 19

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectDown_2() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 19
        model.enemys[0].xPos = 1

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectRightSide_0() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 13
        model.enemys[0].xPos = 3

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectRightSide_1() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 15
        model.enemys[0].xPos = 3

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectRightSide_2() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 17
        model.enemys[0].xPos = 3

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectLeftSide_0() throws {
        model.player.xPos = 3
        model.enemys[0].yPos = 13

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectLeftSide_1() throws {
        model.player.xPos = 3
        model.enemys[0].yPos = 15

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testDoesntIntersectLeftSide_2() throws {
        model.player.xPos = 3
        model.enemys[0].yPos = 17

        let isCollide = collisionHandler!.check()
        XCTAssertFalse(isCollide)
    }

    func testIntersectLeftSide_0() throws {
        model.player.xPos = 2
        model.enemys[0].yPos = 13

        let isCollide = collisionHandler!.check()
        XCTAssertTrue(isCollide)
    }

    func testIntersectLeftSide_1() throws {
        model.player.xPos = 2
        model.enemys[0].yPos = 15

        let isCollide = collisionHandler!.check()
        XCTAssertTrue(isCollide)
    }

    func testIntersectRightSide_0() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 13
        model.enemys[0].xPos = 2

        let isCollide = collisionHandler!.check()
        XCTAssertTrue(isCollide)
    }

    func testIntersectRightSide_1() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 15
        model.enemys[0].xPos = 2

        let isCollide = collisionHandler!.check()
        XCTAssertTrue(isCollide)
    }

    func testIntersectRightSide_2() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 17
        model.enemys[0].xPos = 2

        let isCollide = collisionHandler!.check()
        XCTAssertTrue(isCollide)
    }

    func testIntersectTop() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 11

        let isCollide = collisionHandler!.check()
        XCTAssertTrue(isCollide)
    }

    func testIntersectDown_0() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 18

        let isCollide = collisionHandler!.check()
        XCTAssertTrue(isCollide)
    }

    func testIntersectDown_1() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 18
        model.enemys[0].xPos = 1

        let isCollide = collisionHandler!.check()
        XCTAssertTrue(isCollide)
    }
    
    func testImmortalPlayer() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 18

        _ = collisionHandler!.check()
        
        for _ in 0...5 {
            XCTAssertFalse(collisionHandler!.check())
        }
    }
    
    func testIsNotImmortalPlayer() throws {
        model.player.xPos = 0
        model.enemys[0].yPos = 18

        _ = collisionHandler!.check()
        
        for _ in 0..<RacingDefines.immortalFrames {
            _ = collisionHandler!.check()
        }
        
        XCTAssertTrue(collisionHandler!.check())
    }
}
