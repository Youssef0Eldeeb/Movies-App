//
//  Videos.swift
//  Movies List
//
//  Created by Youssef Eldeeb on 15/08/2021.
//

import Foundation

struct Videos: Codable {
    let id: Int
    let results: [VideoResult]
}
