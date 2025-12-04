//
//  ComposerAPIView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/4/25.
//

import SwiftUI

struct ComposerAPIView: View {
    @StateObject private var service = ComposerAPIService()
    @State private var composer: Composer?
    @State private var searchText = "Bach"
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // API Title
                Text(String(localized: "Composers API"))
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .transition(.opacity)
                
                // Search Section
                VStack(spacing: 10) {
                    Text(String(localized: "Search for a Composer"))
                        .font(.headline)
                    
                    HStack {
                        TextField(String(localized: "Enter composer name"), text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: searchComposer) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color("AccentColor"))
                                .clipShape(Circle())
                        }
                        .disabled(isLoading)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // API Data Display
                if let composer = composer {
                    VStack(alignment: .leading, spacing: 16) {
                        // Data Point 1: Composer Name
                        DataPointView(
                            label: String(localized: "Name"),
                            value: composer.name,
                            icon: "person.fill"
                        )
                        
                        // Data Point 2: Birth Year
                        if let birth = composer.birth {
                            DataPointView(
                                label: String(localized: "Birth Year"),
                                value: "\(birth)",
                                icon: "calendar"
                            )
                        }
                        
                        // Data Point 3: Death Year
                        if let death = composer.death {
                            DataPointView(
                                label: String(localized: "Death Year"),
                                value: "\(death)",
                                icon: "calendar.badge.minus"
                            )
                        }
                        
                        // Data Point 4: Complete Works Status
                        if let complete = composer.complete {
                            DataPointView(
                                label: String(localized: "Works Catalog"),
                                value: complete == "Y" ? String(localized: "Complete") : String(localized: "Incomplete"),
                                icon: "music.note.list"
                            )
                        }
                        
                        // Data Point 5: Composer ID
                        DataPointView(
                            label: String(localized: "Open Opus ID"),
                            value: composer.id,
                            icon: "number"
                        )
                        
                        // API Information
                        VStack(alignment: .leading, spacing: 8) {
                            Text(String(localized: "API Information"))
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text(String(localized: "Source: Open Opus API"))
                                .font(.caption)
                            
                            Text(String(localized: "Endpoint: /composer/list/"))
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 5)
                    .transition(.scale.combined(with: .opacity))
                } else if isLoading {
                    // Loading Animation
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(Color("AccentColor"))
                            .padding()
                        
                        Text(String(localized: "Loading..."))
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 200)
                    .transition(.opacity)
                } else {
                    // Empty State
                    VStack(spacing: 20) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text(String(localized: "No data available"))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text(String(localized: "Search for a composer to see API data"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 200)
                    .transition(.opacity)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(String(localized: "Composer API"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(String(localized: "Load Failed"), isPresented: $showAlert) {
            Button(String(localized: "Retry")) {
                searchComposer()
            }
            Button(String(localized: "Cancel"), role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: composer)
        .onAppear {
            if composer == nil {
                searchComposer()
            }
        }
    }
    
    private func searchComposer() {
        guard !searchText.isEmpty else { return }
        
        Task {
            isLoading = true
            defer { isLoading = false }
            
            let fetchedComposer = await service.fetchComposer(name: searchText)
            await MainActor.run {
                self.composer = fetchedComposer
                if fetchedComposer == nil {
                    alertMessage = String(localized: "Composer not found. Please try a different name.")
                    showAlert = true
                }
            }
        }
    }
}

struct DataPointView: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color("AccentColor"))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
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
