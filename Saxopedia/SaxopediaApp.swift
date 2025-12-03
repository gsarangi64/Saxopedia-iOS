//
//  SaxopediaApp.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

@main
struct SaxopediaApp: App {
    @StateObject private var repertoireService = SaxRepertoireService()
    @StateObject private var settings = SettingsModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .environmentObject(repertoireService)
                    .environmentObject(settings)
            }
        }
    }
}

