//
//  ComposerAPIService.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

@MainActor
class ComposerAPIService: ObservableObject {
    @Published var isLoading = false
    @Published var error: String?
    
    private let baseURL = "https://api.openopus.org/composer/list/search/"
    private var cache: [String: Composer] = [:]
    
    func fetchComposer(name: String) async -> Composer? {
        // Clean the name for URL
        let cleanName = name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "%20")
        
        // Check cache first
        if let cached = cache[cleanName] {
            return cached
        }
        
        isLoading = true
        error = nil
        
        defer { isLoading = false }
        
        guard let url = URL(string: "\(baseURL)\(cleanName).json") else {
            error = "Invalid URL for composer: \(name)"
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode the response
            let decoder = JSONDecoder()
            let response = try decoder.decode(OpenOpusResponse.self, from: data)
            
            if response.status.success == "true", let composer = response.composers.first {
                cache[cleanName] = composer
                return composer
            } else {
                error = "No composer found for: \(name)"
                return nil
            }
            
        } catch {
            self.error = "Failed to fetch composer: \(error.localizedDescription)"
            return nil
        }
    }
}
