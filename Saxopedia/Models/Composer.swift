//
//  Composer.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

struct OpenOpusResponse: Decodable {
    let status: Status
    let composers: [Composer]
}

struct Status: Decodable {
    let success: String
}

struct Composer: Identifiable, Decodable, Equatable {
    let id: String
    let name: String
    let complete: String?
    let birth: Int?
    let death: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, complete, birth, death
    }
}
