//
//  SaxRepertoireService.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

class SaxRepertoireService: ObservableObject {
    @Published var pieces: [SaxPiece] = []
    @Published var isLoading = false
    
    private let urlString = "https://raw.githubusercontent.com/gsarangi64/sax-repertoire-data/main/sax_repertoire.json"
    
    func loadRepertoire() async {
        guard let url = URL(string: urlString) else { return }
        
        isLoading = true
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedPieces = try JSONDecoder().decode([SaxPiece].self, from: data)
            
            await MainActor.run {
                self.pieces = decodedPieces.sorted { $0.title < $1.title }
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                print("Error loading repertoire: \(error)")
            }
        }
    }
}

