//
//  APIRepository.swift
//  APITest
//
//  Created by Ram Mhapasekar on 06/07/21.
//

import Foundation

class APIRepository{
  var session: URLSession!
  
  func getMovies(completion: @escaping ([Movie]?, Error?) -> Void) {
    guard let url = URL(string: "https://mymovieslist.com/topmovies")
    else { fatalError() }
    session.dataTask(with: url) { (data, response, error) in
      guard error == nil else {
        completion(nil, error)
        return
      }
      guard let data = data else {
        completion(nil, NSError(domain: "no data", code: 10, userInfo: nil))
        return
      }
      do {
        let movies = try JSONDecoder().decode([Movie].self, from: data)
        completion(movies, nil)
      } catch {
        completion(nil, error)
      }
    }.resume()
  }
}

class MockSession: URLSession {
  
  var cachedUrl: URL?
  var completionHandler: ((Data, URLResponse, Error) -> Void)?
  static var urlResponse: (data: Data?, URLResponse: URLResponse?, error: Error?)
  
  override class var shared: URLSession {
    return MockSession()
  }
  
  override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    self.cachedUrl = url
    self.completionHandler = completionHandler
    return MockTask(response: MockSession.urlResponse, completionHandler: completionHandler)
  }
  
  override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    self.completionHandler = completionHandler
    return MockTask(response: MockSession.urlResponse, completionHandler: completionHandler)
  }
  
}

class MockTask: URLSessionDataTask {
  
  typealias Response = (data: Data?, URLResponse: URLResponse?, error: Error?)
  var urlResponse: Response
  let completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
  
  init(response: Response, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
    self.urlResponse = response
    self.completionHandler = completionHandler
  }
  
  override func resume() {
    completionHandler!(urlResponse.data, urlResponse.URLResponse, urlResponse.error)
  }
}


//class MockURLSession: URLSession {
//  var cachedUrl: URL?
//
//  private let mockTask: MockTask
//
//   init(data: Data?, urlResponse: URLResponse?, error: Error?) {
//     mockTask = MockTask(data: data, urlResponse: urlResponse, error: error)
//   }
//
//  override func dataTask(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//    self.cachedUrl = url
//    mockTask.completionHandler = completionHandler
//
//    return URLSession(configuration: .default).dataTask(with: url)
//  }
//}

//class MockTask: URLSessionDataTask {
//  private let data: Data?
//  private let urlResponse: URLResponse?
//  private let err: Error?
//
//  var completionHandler: ((Data?, URLResponse?, Error?) -> Void)
//
//  init(data: Data?, urlResponse: URLResponse?, error: Error?) {
//    self.data = data
//    self.urlResponse = urlResponse
//    self.err = error
//  }
//
//  override func resume() {
//    DispatchQueue.main.async {
//      self.completionHandler(self.data, self.urlResponse, self.err)
//    }
//  }
//}

