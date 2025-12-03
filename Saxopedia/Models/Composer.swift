//
//  Composer.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

struct Composer: Identifiable, Decodable {
    var id: UUID = UUID()
    let name: String
    let birthYear: Int?
    let deathYear: Int?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, birthYear, deathYear, bio
    }
}
