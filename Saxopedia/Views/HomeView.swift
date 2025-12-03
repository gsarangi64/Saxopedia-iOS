//
//  ContentView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var repertoireService: SaxRepertoireService
    
    var body: some View {
        List {
            Section {
                NavigationLink("Browse Repertoire") {
                    RepertoireListView()
                }
            }
            
            Section {
                NavigationLink("Settings") {
                    SettingsView()
                }
                
                NavigationLink("About") {
                    InfoView()
                }
            }
        }
        .navigationTitle("Saxopedia")
        .task {
            if repertoireService.pieces.isEmpty {
                await repertoireService.loadRepertoire()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SaxRepertoireService())
}
