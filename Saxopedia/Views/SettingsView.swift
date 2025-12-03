//
//  SettingsView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsModel
    
    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $settings.darkMode)
            }
            
            Section("Content") {
                Toggle("Show Composer Info", isOn: $settings.showComposerInfo)
            }
            
            Section("Data Sources") {
                Link("Saxophone Repertoire JSON",
                     destination: URL(string: "https://raw.githubusercontent.com/gsarangi64/sax-repertoire-data/main/sax_repertoire.json")!)
                Link("Open Opus API",
                     destination: URL(string: "https://api.openopus.org")!)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(SettingsModel())
    }
}
