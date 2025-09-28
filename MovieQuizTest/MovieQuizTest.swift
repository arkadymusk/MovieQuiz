//
//  MovieQuizTest.swift
//  MovieQuizTest
//
//  Created by Аркадий Червонный on 18.09.2025.
//

import XCTest

struct ArithmeticOperations {
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    func subtraction(num1: Int, num2: Int) -> Int {
        return num1 - num2
    }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}

class MovieQuizTest: XCTestCase {

    func testAddition() throws {
        //Given
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        //When
        let result = arithmeticOperations.addition(num1: num1, num2: num2)
        
        //Then
        XCTAssertEqual(result, 3)
    }
}
