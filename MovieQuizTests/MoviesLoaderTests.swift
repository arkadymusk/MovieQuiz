//
//  MoviesLoaderTests.swift
//  MovieQuiz
//
//  Created by Аркадий Червонный on 18.09.2025.
//

import XCTest

@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        //Given
        let stubetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubetworkClient)
        
        //When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            //Then
            
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        //Given
        let stubetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubetworkClient)
        
        //When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            //Then
            
            switch result {
            case .success(_):
                XCTFail("Unexpected failure")
            case let error:
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
}
