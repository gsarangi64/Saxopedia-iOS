//
//  RepertoireDetailView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct RepertoireDetailView: View {
    let piece: SaxPiece
    @EnvironmentObject var composerService: ComposerAPIService
    @EnvironmentObject var settings: SettingsModel
    @State private var composer: Composer?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(piece.title)
                    .font(.largeTitle)
                    .bold()
                
                // Composer
                Text(piece.composer)
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                // Details
                VStack(alignment: .leading, spacing: 8) {
                    detailRow("Year", "\(piece.year)")
                    detailRow("Instrumentation", piece.instrumentation)
                    detailRow("Difficulty", piece.difficulty)
                    detailRow("Duration", piece.duration)
                    detailRow("Publisher", piece.publisher)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                // Composer Info
                if settings.showComposerInfo {
                    composerSection
                }
                
                // Notes
                if !piece.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        Text(piece.notes)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                // Recording Link
                if let url = URL(string: piece.recording_url), !piece.recording_url.isEmpty {
                    Link(destination: url) {
                        Label("Listen to Recording", systemImage: "play.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(piece.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            composer = await composerService.fetchComposer(name: piece.composer)
        }
    }
    
    private func detailRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
                .frame(width: 120, alignment: .leading)
            Text(value)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    private var composerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Composer Information")
                .font(.headline)
            
            if let composer = composer {
                if let birth = composer.birth, let death = composer.death {
                    Text("\(birth) - \(death)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let bio = composer.complete {
                    Text(bio)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Composer information not available")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        RepertoireDetailView(piece: SaxPiece(
            title: "Test Piece",
            composer: "Test Composer",
            year: 2023,
            instrumentation: "Alto Sax",
            difficulty: "Intermediate",
            duration: "5:00",
            publisher: "Test",
            recording_url: "",
            notes: "Test notes"
        ))
        .environmentObject(ComposerAPIService())
        .environmentObject(SettingsModel())
    }
}
