//
//  RepertoireAPIView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/4/25.
//

import SwiftUI

struct RepertoireAPIView: View {
    @StateObject private var service = SaxRepertoireService()
    @State private var isRefreshing = false
    
    // Extract difficulty distribution to a computed property
    private var difficultyDistribution: [(difficulty: String, count: Int, percentage: Int)] {
        let difficulties = Dictionary(grouping: service.pieces, by: { $0.difficulty })
        let totalPieces = service.pieces.count
        
        return difficulties.keys
            .sorted()
            .prefix(3)
            .compactMap { difficulty in
                guard let count = difficulties[difficulty]?.count, totalPieces > 0 else { return nil }
                let percentage = Int(Double(count) / Double(totalPieces) * 100)
                return (difficulty, count, percentage)
            }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // API Title
                Text(String(localized: "Repertoire API"))
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .transition(.opacity)
                
                // API Statistics Card
                VStack(spacing: 16) {
                    Text(String(localized: "API Statistics"))
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    // Data Point 1: Total Pieces
                    StatCard(
                        label: String(localized: "Total Pieces"),
                        value: "\(service.pieces.count)",
                        icon: "music.note.list",
                        color: Color("AccentColor")
                    )
                    
                    // Data Point 2: Sample Piece Title
                    if let firstPiece = service.pieces.first {
                        StatCard(
                            label: String(localized: "Sample Piece"),
                            value: firstPiece.title,
                            icon: "music.note",
                            color: .green
                        )
                    }
                    
                    // Data Point 3: Sample Composer
                    if let firstPiece = service.pieces.first {
                        StatCard(
                            label: String(localized: "Sample Composer"),
                            value: firstPiece.composer,
                            icon: "person.fill",
                            color: .orange
                        )
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Detailed API Data
                if !service.pieces.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(String(localized: "Detailed API Data"))
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Data Point 4: Earliest Piece
                        if let earliest = service.pieces.min(by: { $0.year < $1.year }) {
                            DataRowView(
                                title: String(localized: "Earliest Piece"),
                                subtitle: "\(earliest.year)",
                                detail: earliest.title,
                                icon: "clock.arrow.circlepath"
                            )
                        }
                        
                        // Data Point 5: Most Recent Piece
                        if let latest = service.pieces.max(by: { $0.year < $1.year }) {
                            DataRowView(
                                title: String(localized: "Most Recent Piece"),
                                subtitle: "\(latest.year)",
                                detail: latest.title,
                                icon: "clock.fill"
                            )
                        }
                        
                        // Data Point 6: Difficulty Distribution - Simplified
                        ForEach(difficultyDistribution, id: \.difficulty) { item in
                            DataRowView(
                                title: "\(item.difficulty) \(String(localized: "Pieces"))",
                                subtitle: "\(item.count)",
                                detail: "\(item.percentage)%",
                                icon: "chart.bar.fill"
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 5)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                // API Information
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "API Information"))
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    InfoRow(label: String(localized: "Data Source"), value: "GitHub JSON API")
                    InfoRow(label: String(localized: "Endpoint"), value: "https://raw.githubusercontent.com/...")
                    InfoRow(label: String(localized: "Format"), value: "JSON Array")
                    InfoRow(label: String(localized: "Last Updated"), value: "2025")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                // Refresh Button with Animation
                Button(action: refreshData) {
                    HStack {
                        if isRefreshing {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                        Text(String(localized: "Refresh API Data"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(isRefreshing)
                .padding(.horizontal)
                .animation(.easeInOut, value: isRefreshing)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(String(localized: "Repertoire API"))
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if service.isLoading && service.pieces.isEmpty {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Color("AccentColor"))
                    
                    Text(String(localized: "Loading..."))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground).opacity(0.9))
                .transition(.opacity)
            }
        }
//        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: service.pieces)
        .task {
            if service.pieces.isEmpty {
                await service.loadRepertoire()
            }
        }
    }
    
    private func refreshData() {
        Task {
            isRefreshing = true
            defer { isRefreshing = false }
            
            await service.loadRepertoire()
        }
    }
}

struct StatCard: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title3)
                    .bold()
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: color.opacity(0.1), radius: 3)
    }
}

struct DataRowView: View {
    let title: String
    let subtitle: String
    let detail: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color("AccentColor"))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(detail)
                .font(.headline)
        }
        .padding(.vertical, 8)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.caption)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    NavigationStack {
        RepertoireAPIView()
    }
}
