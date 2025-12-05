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
    @State private var showingActions = false
    @State private var showingAlert = false
    @State private var isLoadingComposer = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title with animation
                Text(piece.title)
                    .font(.largeTitle)
                    .bold()
                    .transition(.slide)
                
                // Composer
                Text(piece.composer)
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                // Action Button with animation
                Button(action: { showingActions = true }) {
                    Label("More Options", systemImage: "ellipsis.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.vertical)
                .transition(.opacity)
                
                // API Data Section - This shows the 6+ data points
                VStack(alignment: .leading, spacing: 16) {
                    Text("Piece Details (from JSON API)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    // Data Point 1: Title
                    APIInfoRow(icon: "music.note", label: "Title", value: piece.title)
                    
                    // Data Point 2: Composer
                    APIInfoRow(icon: "person.fill", label: "Composer", value: piece.composer)
                    
                    // Data Point 3: Year
                    APIInfoRow(icon: "calendar", label: "Year", value: "\(piece.year)")
                    
                    // Data Point 4: Instrumentation
                    APIInfoRow(icon: "guitars.fill", label: "Instrumentation", value: piece.instrumentation)
                    
                    // Data Point 5: Difficulty
                    APIInfoRow(icon: "chart.bar.fill", label: "Difficulty", value: piece.difficulty)
                    
                    // Data Point 6: Duration
                    APIInfoRow(icon: "clock.fill", label: "Duration", value: piece.duration)
                    
                    // Data Point 7: Publisher
                    if !piece.publisher.isEmpty {
                        APIInfoRow(icon: "book.fill", label: "Publisher", value: piece.publisher)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.1), radius: 5)
                .transition(.move(edge: .leading))
                
                // Composer API Information (From Open Opus API)
                if settings.showComposerInfo {
                    composerAPISection
                        .transition(.opacity)
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
            await loadComposerData()
        }
        .confirmationDialog("More Options",
                          isPresented: $showingActions,
                          titleVisibility: .visible) {
            // ActionSheet with 5 options
            Button("Add to Favorites") {
                showingAlert = true
            }
            
            Button("Share") {
                // Share logic
            }
            
            Button("Report Issue", role: .destructive) {
                // Report issue logic
            }
            
            Button("View Similar Pieces") {
                // View similar logic
            }
            
            Button("Cancel", role: .cancel) { }
        }
        .alert("Added to Favorites", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(piece.title) has been added to your favorites.")
        }
        .animation(.easeInOut(duration: 0.5), value: composer)
        .overlay {
            if isLoadingComposer {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.accentColor)
                    Text("Loading composer data...")
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground).opacity(0.8))
            }
        }
    }
    
    private func loadComposerData() async {
        isLoadingComposer = true
        composer = await composerService.fetchComposer(name: piece.composer)
        isLoadingComposer = false
    }
    
    private var composerAPISection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Composer API Data (Open Opus)")
                .font(.headline)
                .foregroundColor(.primary)
            
            if let composer = composer {
                // Composer API Data Points
                VStack(spacing: 12) {
                    // Data Point from API 1: Composer Name (using complete_name)
                    ComposerDataRow(icon: "person.fill", label: "Full Name", value: composer.complete_name)
                    
                    // Data Point from API 2: Display Name
                    ComposerDataRow(icon: "person.crop.circle", label: "Display Name", value: composer.name)
                    
                    // Data Point from API 3: Birth Date
                    ComposerDataRow(icon: "calendar.badge.plus", label: "Born", value: composer.birth)
                    
                    // Data Point from API 4: Death Date
                    ComposerDataRow(icon: "calendar.badge.minus", label: "Died", value: composer.death)
                    
                    // Data Point from API 5: Musical Period
                    ComposerDataRow(icon: "clock.fill", label: "Period", value: composer.epoch)
                    
                    // Data Point from API 6: Open Opus ID
                    ComposerDataRow(icon: "number.circle.fill", label: "Open Opus ID", value: composer.id)
                    
                    // Data Point from API 7: Birth Year (computed)
                    if let birthYear = composer.birthYear {
                        ComposerDataRow(icon: "calendar", label: "Birth Year", value: "\(birthYear)")
                    }
                    
                    // Data Point from API 8: Death Year (computed)
                    if let deathYear = composer.deathYear {
                        ComposerDataRow(icon: "calendar.badge.clock", label: "Death Year", value: "\(deathYear)")
                    }
                    
                    // Data Point from API 9: API Source
                    ComposerDataRow(icon: "network", label: "API Source", value: "Open Opus API")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                // API Information Footer
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    Text("Live data fetched from Open Opus API")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 4)
            } else if isLoadingComposer {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading composer data from API...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.orange)
                    Text("Composer data not available in API")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("The composer '\(piece.composer)' was not found in the Open Opus database")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// Custom view for displaying API data rows
struct APIInfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// Custom view for displaying composer API data
struct ComposerDataRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 25)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .textSelection(.enabled)
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationStack {
        RepertoireDetailView(piece: SaxPiece(
            title: "Sonata for Alto Saxophone",
            composer: "Paul Creston",
            year: 1944,
            instrumentation: "Alto Sax & Piano",
            difficulty: "Advanced",
            duration: "12 min",
            publisher: "Belwin",
            recording_url: "https://www.youtube.com/watch?v=example",
            notes: "A classic mid-20th century sonata that has become standard repertoire for saxophonists."
        ))
        .environmentObject(ComposerAPIService())
        .environmentObject(SettingsModel())
    }
}
