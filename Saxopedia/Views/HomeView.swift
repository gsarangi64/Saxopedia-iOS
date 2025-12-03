//
//  ContentView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var service: SaxRepertoireService

    var body: some View {
        NavigationStack {
            VStack {
                Text("Saxophone Repertoire Explorer")
                    .font(.title2)
                    .padding(.top)

                NavigationLink("Browse Repertoire") {
                    RepertoireListView()
                }
                .padding()

                NavigationLink("Settings") {
                    SettingsView()
                }
                .padding()

                NavigationLink("App Info") {
                    InfoView()
                }
                .padding()
            }
//            .task {
//                await service.fetchRepertoire()
//            }
        }
    }
}

#Preview {
    HomeView()
}
