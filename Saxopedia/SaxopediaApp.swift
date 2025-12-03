//
//  SaxopediaApp.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

@main
struct SaxopediaApp: App {
    @StateObject var repertoireService = SaxRepertoireService()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(repertoireService)
        }
    }
}
