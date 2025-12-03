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
    let source: String?
    let rows: Int?
}

struct Composer: Identifiable, Decodable {
    let id: String
    let name: String
    let complete: String?
    let birth: Int?
    let death: Int?
    let epoch: String?
    let portrait: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, complete, birth, death, epoch, portrait
    }
}
