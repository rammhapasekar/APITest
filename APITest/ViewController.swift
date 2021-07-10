//
//  ViewController.swift
//  APITest
//
//  Created by Ram Mhapasekar on 06/07/21.
//

import UIKit

class ViewController: UIViewController {

  var apiRepository: APIRepository!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemTeal
    
    apiRepository = APIRepository()
    apiRepository.session = URLSession(configuration: .default)
    apiRepository.getMovies{ movies, error in
      guard let moviesArray = movies else{
        assert(movies == nil, "movies response is empty")
        return
      }
      
      guard let err = error else{
        assert(error == nil, "error is empty")
        return
      }
      
      print("fetched movies : ",moviesArray)
      print("error while fetching movie list : ",err)
    }
  }
}

