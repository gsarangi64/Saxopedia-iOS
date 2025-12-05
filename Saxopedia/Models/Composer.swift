//
//  Composer.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

struct OpenOpusResponse: Decodable {
    let status: Status
    let request: Request?
    let composers: [Composer]
}

struct Status: Decodable {
    let version: String
    let success: String
    let source: String
    let rows: Int
    let processingtime: Double
    let api: String
}

struct Request: Decodable {
    let type: String
    let item: String
}

struct Composer: Identifiable, Decodable, Equatable {
    let id: String
    let name: String
    let complete_name: String
    let birth: String
    let death: String
    let epoch: String
    let portrait: String?
    
    // Computed property to get birth year as Int
    var birthYear: Int? {
        let yearString = birth.prefix(4)
        return Int(yearString)
    }
    
    // Computed property to get death year as Int
    var deathYear: Int? {
        let yearString = death.prefix(4)
        return Int(yearString)
    }
    
    // Implement Equatable
    static func == (lhs: Composer, rhs: Composer) -> Bool {
        return lhs.id == rhs.id
    }
}
