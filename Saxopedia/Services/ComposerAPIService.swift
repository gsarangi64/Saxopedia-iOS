//
//  ComposerAPIService.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import Foundation

@MainActor
class ComposerAPIService: ObservableObject {
    @Published var composerInfo: [String: Composer] = [:]

    func fetchComposer(name: String) async -> Composer {
        // Replace with real API call if available
        if let composer = composerInfo[name] {
            return composer
        }

        // Dummy stub
        let dummy = Composer(
            name: name,
            birthYear: nil,
            deathYear: nil,
            bio: "Biography for \(name) not available yet."
        )
        composerInfo[name] = dummy
        return dummy
    }
}
