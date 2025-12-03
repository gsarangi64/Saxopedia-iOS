//
//  SaxPiece.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

struct SaxPiece: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let composer: String
    let year: Int
    let instrumentation: String
    let difficulty: String
    let duration: String
    let publisher: String
    let recording_url: String
    let notes: String
}
