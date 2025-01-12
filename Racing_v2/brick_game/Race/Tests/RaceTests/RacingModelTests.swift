import Testing
import XCTest
import Foundation

@testable import Race


class RacingModelUnitTest: XCTestCase {
    var model: RacingModel!
    
    override func setUpWithError() throws {
        model = RacingModel()
    }
    
    func testLevelSetter() async throws {
        let livesBefore = model.lives
        
        model.lives = -1
        
        let livesAfter = model.lives
        
        XCTAssertEqual(livesBefore, livesAfter)
    }
    
    func testSpeedSetter() async throws {
        let speedBefore = model.speed
        
        model.speed = -1
        
        let speedAfter = model.speed
        
        XCTAssertEqual(speedBefore, speedAfter)
    }
    
    func testPlaceObjects() async throws {
        let speedBefore = model.speed
        
        model.speed = -1
        
        let speedAfter = model.speed
        
        XCTAssertEqual(speedBefore, speedAfter)
    }
    
    func testPlaceObjectOnField() async throws {
        let fieldIsEmptyBefore = checkEmptyField()
        
        _ = model.placeObjectOnField()
        
        let fieldIsEmptyAfter = checkEmptyField()

        XCTAssertNotEqual(fieldIsEmptyBefore, fieldIsEmptyAfter)
    }
    
    func checkEmptyField() -> Bool {
        var fieldIsEmpty = true
        for row in 0..<RacingDefines.yBorderSize {
            
            guard fieldIsEmpty else {
                break
            }
            
            for cell in 0..<RacingDefines.xBorderSize {
                if model.gameInfo.field[row]?[cell] != 0 {
                    fieldIsEmpty = false
                    break
                }
            }
        }
        
        return fieldIsEmpty
    }
}

