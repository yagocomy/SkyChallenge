//
//  ManagerAPI.swift
//  Sky Mobile Test
//
//  Created by Vitor Augusto Araujo Silva on 30/10/20.
//

import Foundation
import Alamofire

class ManagerAPI {
    
    static let shared = ManagerAPI()
    
    
    func getMovies(completionHandler: @escaping ([Movies]?) -> Void) {
        let apiURL = "https://sky-exercise.herokuapp.com/api/Movies"
        
        guard let url = URL(string: apiURL) else {
            print("Erro ao criar URL")
            completionHandler(nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 10.0
        
        Alamofire.request(urlRequest).responseData { (response) in
            if response.error == nil, let apiResponse = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [Dictionary<String, Any>] {
                
                var movies: [Movies] = []
                
                for movie in apiResponse {
                    if let title = movie["title"] as? String,
                       let overview = movie["overview"] as? String,
                       let duration = movie["duration"] as? String,
                       let release_year = movie["release_year"] as? String,
                       let cover_url = movie["cover_url"] as? String,
                       let id = movie["id"] as? String {
                        
                        movies.append(Movies(title: title, overview: overview, duration: duration, release_year: release_year, cover_url: cover_url, backdrops_url: ["A"], id: id))
                    }
                }
                completionHandler(movies)
                
            } else {
                completionHandler(nil)
            }
    
        }
        completionHandler(nil)
    }

}

