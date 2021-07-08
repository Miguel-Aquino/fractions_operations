//
//  FractionsTests.swift
//  FractionsTests
//
//  Created by Miguel Aquino on 07/07/21.
//

import XCTest
@testable import OneLogin

class FractionsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testAddition() {
        
        let operation = "3_1/2 + 2_3/5"
        let expectedResult = "= 6_1/10"

        let result = Fractions.shared.resolve(operation: operation)

        print(result)
        XCTAssert(result == expectedResult)
    }
    
    func testSubtraction() {
        
        let operation = "4_5/4 - 2_1/2"
        let expectedResult = "= 2_3/4"

        let result = Fractions.shared.resolve(operation: operation)

        print(result)
        XCTAssert(result == expectedResult)
    }
    
    func testMultiplication() {
        let operation = "3_1/2 * 1_3/4"
        let expectedResult = "= 6_1/8"

        let result = Fractions.shared.resolve(operation: operation)

        print(result)
        XCTAssert(result == expectedResult)
    }
    
    func testDivision() {
        let operation = "4_3/2 / 6_5/4"
        let expectedResult = "= 44/58"

        let result = Fractions.shared.resolve(operation: operation)

        print(result)
        XCTAssert(result == expectedResult)
    }
}
