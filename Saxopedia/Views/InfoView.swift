//
//  InfoView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct InfoView: View {
    @EnvironmentObject var repertoireService: SaxRepertoireService
    
    var body: some View {
        Form {
            // App Icon Section
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Image("AppIcon")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .transition(.scale)
                        
                        Text(Bundle.main.appName)
                            .font(.headline)
                    }
                    .padding(.vertical)
                    Spacer()
                }
            }
            
            // App Info Section
            Section(String(localized: "App Info")) {
                InfoRowView(label: String(localized: "Name"), value: Bundle.main.appName)
                InfoRowView(label: String(localized: "Version"), value: Bundle.main.version)
                InfoRowView(label: String(localized: "Build"), value: Bundle.main.buildNumber)
                InfoRowView(label: String(localized: "Copyright"), value: Bundle.main.copyright)
            }
            
            // Data Section
            Section(String(localized: "Data")) {
                InfoRowView(
                    label: String(localized: "Pieces Loaded"),
                    value: "\(repertoireService.pieces.count)"
                )
            }
            
            // Credits Section
            Section(String(localized: "Credits")) {
                Link("Open Opus API", destination: URL(string: "https://api.openopus.org")!)
                Link("Saxophone Repertoire Data", destination: URL(string: "https://github.com/gsarangi64/sax-repertoire-data")!)
            }
        }
        .navigationTitle(String(localized: "About"))
    }
}

struct InfoRowView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
        .transition(.opacity)
    }
}

#Preview {
    NavigationStack {
        InfoView()
            .environmentObject(SaxRepertoireService())
    }
}
