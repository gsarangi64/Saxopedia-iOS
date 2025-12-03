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
            Section("App") {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Saxopedia")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Data") {
                HStack {
                    Text("Pieces Loaded")
                    Spacer()
                    Text("\(repertoireService.pieces.count)")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("About")
    }
}

#Preview {
    NavigationStack {
        InfoView()
            .environmentObject(SaxRepertoireService())
    }
}
