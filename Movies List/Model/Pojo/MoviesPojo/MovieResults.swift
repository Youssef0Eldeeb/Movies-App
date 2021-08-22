//
//  Results.swift
//  Movies List
//
//  Created by Youssef Eldeeb on 14/08/2021.
//

import Foundation

struct Result: Codable {
    
    let id: Int
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate: String
    let voteAverage: Double
    

    
    enum CodingKeys: String, CodingKey {
            
            case id
            case originalTitle = "original_title"
            case overview, popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
            
        }
    
}
