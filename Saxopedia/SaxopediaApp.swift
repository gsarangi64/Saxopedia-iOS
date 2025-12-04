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
    @StateObject private var composerService = ComposerAPIService()
    @StateObject private var settings = SettingsModel()
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .environmentObject(repertoireService)
            .environmentObject(composerService)
            .environmentObject(settings)
            .environmentObject(notificationManager)
            .preferredColorScheme(settings.darkMode ? .dark : .light)
            .task {
                await notificationManager.checkAuthorizationStatus()
            }
        }
    }
}
