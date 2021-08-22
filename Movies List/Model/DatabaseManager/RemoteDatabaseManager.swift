//
//  RemoteDatabaseManager.swift
//  Movies List
//
//  Created by Youssef Eldeeb on 14/08/2021.
//

import Foundation
import Alamofire

class ApiManager {
    
    func fetchData (completion: @escaping ([Result]?,String?) -> Void){
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=a6495d97b98ad9f8e88dc2c909c3f80e")
        let request = AF.request(url!, method: .get, encoding: JSONEncoding.default)
        request.responseJSON { (responsData) in
            if let data = responsData.data{
                let decoder = JSONDecoder()
                if let decodedObj = try? decoder.decode(MovieMenu.self, from: data){
                    completion(decodedObj.results, nil)
                }
            }
            if let error = responsData.error{
                completion(nil, error.localizedDescription)
            }
        }
        
    }
    
    
    
    
    
    func fectchVideos(key:Int , completion: @escaping ([VideoResult]?,String?) -> Void)  {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(key)/videos?api_key=a6495d97b98ad9f8e88dc2c909c3f80e")
        let request = AF.request(url!, method: .get, encoding: JSONEncoding.default)
        request.responseJSON { (responsData) in
            if let data = responsData.data{
                let decoder = JSONDecoder()
                if let decodedObj = try? decoder.decode(Videos.self, from: data){
                    completion(decodedObj.results, nil)
                }
            }
            if let error = responsData.error{
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
  
    
    
    
    
    func fectchReview(key:Int , completion: @escaping ([ReviewResult]?,String?) -> Void)  {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(key)/reviews?api_key=a6495d97b98ad9f8e88dc2c909c3f80e")
        let request = AF.request(url!, method: .get, encoding: JSONEncoding.default)
        request.responseJSON { (responsData) in
            if let data = responsData.data{
                let decoder = JSONDecoder()
                if let decodedObj = try? decoder.decode(Review.self, from: data){
                    completion(decodedObj.results, nil)
                }
            }
            if let error = responsData.error{
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
}
