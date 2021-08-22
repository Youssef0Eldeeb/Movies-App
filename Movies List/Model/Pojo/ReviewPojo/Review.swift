//
//  VideoReview.swift
//  Movies List
//
//  Created by Youssef Eldeeb on 16/08/2021.
//

import Foundation

struct Review: Codable {
    let id, page: Int
    let results: [ReviewResult]
}
