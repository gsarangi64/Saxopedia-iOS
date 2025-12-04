//
//  ContentView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var repertoireService: SaxRepertoireService
    @State private var showAlert = false
    
    var body: some View {
        List {
            Section(String(localized: "API Data")) {
                NavigationLink(destination: ComposerAPIView()) {
                    Label(String(localized: "Composers API"), systemImage: "person.3.fill")
                        .foregroundColor(Color("AccentColor"))
                }
                .transition(.slide)
                
                NavigationLink(destination: RepertoireAPIView()) {
                    Label(String(localized: "Repertoire API"), systemImage: "music.note.list")
                        .foregroundColor(Color("AccentColor"))
                }
                .transition(.slide)
            }
            
            Section(String(localized: "Repertoire")) {
                NavigationLink(destination: RepertoireListView()) {
                    Label(String(localized: "Browse Repertoire"), systemImage: "magnifyingglass")
                }
            }
            
            Section {
                NavigationLink(destination: SettingsView()) {
                    Label(String(localized: "Settings"), systemImage: "gearshape")
                }
                
                NavigationLink(destination: InfoView()) {
                    Label(String(localized: "About"), systemImage: "info.circle")
                }
            }
        }
        .navigationTitle(String(localized: "Saxopedia"))
        .task {
            if repertoireService.pieces.isEmpty {
                await repertoireService.loadRepertoire()
                if repertoireService.pieces.isEmpty {
                    showAlert = true
                }
            }
        }
        .alert(String(localized: "Load Failed"), isPresented: $showAlert) {
            Button(String(localized: "Retry")) {
                Task {
                    await repertoireService.loadRepertoire()
                }
            }
            Button(String(localized: "Cancel"), role: .cancel) { }
        } message: {
            Text(String(localized: "There was an error loading the repertoire. Please check your connection and try again."))
        }
        .animation(.easeInOut(duration: 0.3), value: repertoireService.pieces.isEmpty)
    }
}

#Preview {
    HomeView()
        .environmentObject(SaxRepertoireService())
}
