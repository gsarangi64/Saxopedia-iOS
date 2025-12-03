//
//  ComposerAPIService.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

class ComposerAPIService: ObservableObject {
    private let baseURL = "https://api.openopus.org/composer/list/search/"
    
    func fetchComposer(name: String) async -> Composer? {
        let cleanedName = name.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(baseURL)\(cleanedName).json"
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(OpenOpusResponse.self, from: data)
            
            if response.status.success == "true" && !response.composers.isEmpty {
                return response.composers[0]
            }
        } catch {
            print("Error fetching composer \(name): \(error)")
        }
        
        return nil
    }
}
