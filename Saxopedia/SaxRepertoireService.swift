//
//  SaxRepertoireService.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

@MainActor
class SaxRepertoireService: ObservableObject {
    @Published var pieces: [SaxPiece] = []

    private let url = URL(string:
        "https://raw.githubusercontent.com/gsarangi64/sax-repertoire-data/main/sax_repertoire.json"
    )!

    func fetchRepertoire() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([SaxPiece].self, from: data)
            pieces = decoded
        } catch {
            print("Error fetching repertoire:", error)
        }
    }
}
