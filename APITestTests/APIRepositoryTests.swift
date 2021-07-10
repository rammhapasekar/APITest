//
//  APIRepositoryTests.swift
//  APITestTests
//
//  Created by Ram Mhapasekar on 06/07/21.
//

import XCTest
@testable import APITest

class APIRepositoryTests: XCTestCase {
  
  //test to check correctness if the given URL
  func testGetMoviesWithExpectedURLHostAndPath(){
    let apiRepository = APIRepository()
    let mockURLSession = MockSession()
    apiRepository.session = mockURLSession
    
    apiRepository.getMovies{ movies, error in }
    XCTAssertEqual(mockURLSession.cachedUrl?.host, "mymovieslist.com")
    XCTAssertEqual(mockURLSession.cachedUrl?.path, "/topmovies")
  }
  
  //Empty movie list return in the response
  func testGetMoviesWhenEmptyDataReturnsError() {
    let apiRespository = APIRepository()
    let mockURLSession  = MockSession()
    MockSession.urlResponse = (data: nil, URLResponse: nil, error: nil)
    apiRespository.session = mockURLSession
    
    let errorExpectation = expectation(description: "error")
    var errorResponse: Error?
    
    apiRespository.getMovies { (movies, error) in
      errorResponse = error
      errorExpectation.fulfill()
    }
    waitForExpectations(timeout: 1) { (error) in
      XCTAssertNotNil(errorResponse)
    }
  }

  
  //successfully able to fetch movie list from the given URL
  func testGetMoviesSuccessReturnsMovies() {
    let jsonData = "[{\"title\": \"Mission Impossible Fallout\",\"detail\": \"A Tom Cruise Movie\"}]".data(using: .utf8)
    let apiRespository = APIRepository()
    let mockURLSession  = MockSession()
    MockSession.urlResponse = (data: jsonData, URLResponse: nil, error: nil)
    apiRespository.session = mockURLSession
    
    let moviesExpectation = expectation(description: "movies")
    var moviesResponse: [Movie]?
    
    apiRespository.getMovies { (movies, error) in
      moviesResponse = movies
      moviesExpectation.fulfill()
    }
    waitForExpectations(timeout: 1) { (error) in      XCTAssertNotNil(moviesResponse)
    }
  }
  
  //error while fetching the movie list from the given URL
  func testGetMoviesWhenResponseErrorReturnsError() {
    let apiRespository = APIRepository()
    let error = NSError(domain: "error", code: 1234, userInfo: nil)
    let mockURLSession  = MockSession()
    MockSession.urlResponse = (data: nil, URLResponse: nil, error: error)
    apiRespository.session = mockURLSession
    
    let errorExpectation = expectation(description: "error")
    var errorResponse: Error?
    
    apiRespository.getMovies { (movies, error) in
      errorResponse = error
      errorExpectation.fulfill()
    }
    waitForExpectations(timeout: 1) { (error) in
      XCTAssertNotNil(errorResponse)
    }
  }
    
  //JSON decoding error test
  func testGetMoviesInvalidJSONReturnsError() {
    let jsonData = "[{\"t\"}]".data(using: .utf8)
    let apiRespository = APIRepository()
    let mockURLSession  = MockSession()
    MockSession.urlResponse = (data: jsonData, URLResponse: nil, error: nil)
    apiRespository.session = mockURLSession
    
    let errorExpectation = expectation(description: "error")
    var errorResponse: Error?
    
    apiRespository.getMovies { (movies, error) in
      errorResponse = error
      errorExpectation.fulfill()
    }
    waitForExpectations(timeout: 1) { (error) in
      XCTAssertNotNil(errorResponse)
    }
  }
}
