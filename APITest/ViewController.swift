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
      print("fetched movies : ",movies)
      print("error while fetching movie list : ",error)
    }
  }
}

