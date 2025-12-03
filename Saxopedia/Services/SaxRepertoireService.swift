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
    @Published var isLoading = false
    @Published var error: String?
    
    private let jsonURL = "https://raw.githubusercontent.com/gsarangi64/sax-repertoire-data/main/sax_repertoire.json"
    
    func loadRepertoire() async {
        isLoading = true
        error = nil
        
        defer { isLoading = false }
        
        guard let url = URL(string: jsonURL) else {
            error = "Invalid URL"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decode the JSON
            let decoder = JSONDecoder()
            let decodedPieces = try decoder.decode([SaxPiece].self, from: data)
            
            // Sort by title
            pieces = decodedPieces.sorted { $0.title < $1.title }
            
        } catch {
            self.error = "Failed to load repertoire: \(error.localizedDescription)"
            pieces = []
        }
    }
}
