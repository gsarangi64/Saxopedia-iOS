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
        
        print("Fetching from: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }
            
            let response = try JSONDecoder().decode(OpenOpusResponse.self, from: data)
            
            if response.status.success == "true" && !response.composers.isEmpty {
                print("Found \(response.composers.count) composers")
                return response.composers[0]
            } else {
                print("No composers found or success = false")
                return nil
            }
        } catch {
            print("Error fetching composer \(name): \(error)")
            return nil
        }
    }
    
    func searchComposers(name: String) async -> [Composer] {
        let cleanedName = name.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(baseURL)\(cleanedName).json"
        
        print("Searching from: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return []
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(OpenOpusResponse.self, from: data)
            
            if response.status.success == "true" {
                print("Found \(response.composers.count) composers")
                return response.composers
            } else {
                print("No composers found or success = false")
                return []
            }
        } catch {
            print("Error searching composers \(name): \(error)")
            return []
        }
    }
}
