//
//  SaxPiece.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

struct SaxPiece: Identifiable, Decodable {
    var id: UUID = UUID()

    let title: String
    let composer: String
    let year: Int
    let instrumentation: String
    let difficulty: String
    let duration: String
    let publisher: String
    let recording_url: String
    let notes: String

    private enum CodingKeys: String, CodingKey {
        case title, composer, year, instrumentation, difficulty, duration, publisher, recording_url, notes
    }
}
