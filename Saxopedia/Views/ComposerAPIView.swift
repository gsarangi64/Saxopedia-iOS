//
//  ComposerAPIView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/4/25.
//

import SwiftUI

struct ComposerAPIView: View {
    @StateObject private var service = ComposerAPIService()
    @State private var composers: [Composer] = []
    @State private var selectedComposerID: String?
    @State private var searchText = "Bach"
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showResults = false
    
    // Computed property for selected composer
    private var selectedComposer: Composer? {
        composers.first { $0.id == selectedComposerID } ?? composers.first
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // API Title
                Text("Open Opus API")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .transition(.opacity)
                
                // API Information Card
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "network")
                            .foregroundColor(.blue)
                        Text("Live API Connection")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    
                    Text("Endpoint: GET https://api.openopus.org/composer/list/search/{name}.json")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Returns: Array of composer objects with detailed information")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if !composers.isEmpty {
                        Divider()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("API Status: Connected (\(composers.count) results)")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                // Search Section
                VStack(spacing: 10) {
                    Text("Search Composers")
                        .font(.headline)
                    
                    HStack {
                        TextField("Composer name", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                            .submitLabel(.search)
                            .onSubmit {
                                searchComposers()
                            }
                        
                        Button(action: searchComposers) {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(10)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .disabled(isLoading)
                    }
                    .padding(.horizontal)
                    
                    // Suggested searches
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(["Bach", "Beethoven", "Mozart", "Debussy", "Creston", "Ibert"], id: \.self) { name in
                                Button(name) {
                                    searchText = name
                                    searchComposers()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.accentColor.opacity(0.2))
                                .foregroundColor(.accentColor)
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // API Data Display
                if isLoading {
                    // Loading Animation
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.accentColor)
                        
                        Text("Searching Open Opus API...")
                            .foregroundColor(.secondary)
                        
                        Text("Endpoint: /composer/list/search/\(searchText.replacingOccurrences(of: " ", with: "%20")).json")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 200)
                    .transition(.opacity)
                } else if !composers.isEmpty {
                    // Show API results
                    VStack(alignment: .leading, spacing: 16) {
                        Text("API Results (\(composers.count) found)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        // Composer selection - FIXED
                        Picker("Select Composer", selection: $selectedComposerID) {
                            ForEach(composers) { composer in
                                Text(composer.complete_name).tag(composer.id)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        if let composer = selectedComposer {
                            ComposerDetailCard(composer: composer)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 5)
                } else if showResults {
                    // No results found
                    VStack(spacing: 20) {
                        Image(systemName: "person.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text("No composers found")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Try: Bach, Beethoven, Mozart, Debussy, Creston")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 200)
                    .transition(.opacity)
                } else {
                    // Initial state
                    VStack(spacing: 20) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text("Search for a composer")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Enter a composer name and tap search")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 200)
                    .transition(.opacity)
                }
                
                // API Data Points Section
                if let composer = selectedComposer {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("API Data Points")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        // Data Point 1: Complete Name
                        DataPointView(
                            label: "Full Name",
                            value: composer.complete_name,
                            icon: "person.fill"
                        )
                        
                        // Data Point 2: Birth Date
                        DataPointView(
                            label: "Birth Date",
                            value: composer.birth,
                            icon: "calendar.badge.plus"
                        )
                        
                        // Data Point 3: Death Date
                        DataPointView(
                            label: "Death Date",
                            value: composer.death,
                            icon: "calendar.badge.minus"
                        )
                        
                        // Data Point 4: Epoch/Period
                        DataPointView(
                            label: "Musical Period",
                            value: composer.epoch,
                            icon: "clock.fill"
                        )
                        
                        // Data Point 5: Open Opus ID
                        DataPointView(
                            label: "Open Opus ID",
                            value: composer.id,
                            icon: "number.circle.fill"
                        )
                        
                        // Data Point 6: Portrait URL
                        if let portrait = composer.portrait {
                            DataPointView(
                                label: "Portrait URL",
                                value: portrait,
                                icon: "photo.fill"
                            )
                        }
                        
                        // Data Point 7: Birth Year (computed)
                        if let birthYear = composer.birthYear {
                            DataPointView(
                                label: "Birth Year",
                                value: "\(birthYear)",
                                icon: "calendar"
                            )
                        }
                        
                        // Data Point 8: Death Year (computed)
                        if let deathYear = composer.deathYear {
                            DataPointView(
                                label: "Death Year",
                                value: "\(deathYear)",
                                icon: "calendar.badge.clock"
                            )
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    .transition(.slide)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Composer API")
        .navigationBarTitleDisplayMode(.inline)
        .alert("API Error", isPresented: $showAlert) {
            Button("Retry") {
                searchComposers()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: composers)
        .onAppear {
            if composers.isEmpty {
                searchComposers()
            }
        }
    }
    
    private func searchComposers() {
        guard !searchText.isEmpty else { return }
        
        Task {
            isLoading = true
            showResults = true
            defer {
                isLoading = false
            }
            
            let foundComposers = await service.searchComposers(name: searchText)
            
            await MainActor.run {
                self.composers = foundComposers
                if foundComposers.isEmpty {
                    alertMessage = "No composers found for '\(searchText)'"
                    showAlert = true
                } else {
                    self.selectedComposerID = foundComposers.first?.id
                }
            }
        }
    }
}

struct ComposerDetailCard: View {
    let composer: Composer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(composer.complete_name)
                        .font(.title2)
                        .bold()
                    
                    Text(composer.epoch)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentColor.opacity(0.2))
                        .foregroundColor(.accentColor)
                        .cornerRadius(4)
                }
                
                Spacer()
                
                // Show portrait if available
                if let portraitURL = composer.portrait, let url = URL(string: portraitURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Born")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(composer.birth)
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Died")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(composer.death)
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("ID")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(composer.id)
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct DataPointView: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .textSelection(.enabled)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        ComposerAPIView()
    }
}
