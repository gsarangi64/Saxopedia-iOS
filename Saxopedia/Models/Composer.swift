//
//  Composer.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

struct Composer: Identifiable, Codable {
    let id: UUID
    let name: String
    let birthYear: Int?
    let deathYear: Int?
    let bio: String?
}
