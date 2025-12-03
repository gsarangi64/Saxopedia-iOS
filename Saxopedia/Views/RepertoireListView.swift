//
//  RepertoireListView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct RepertoireListView: View {
    @EnvironmentObject var repertoireService: SaxRepertoireService
    @State private var searchText = ""
    
    var filteredPieces: [SaxPiece] {
        if searchText.isEmpty {
            return repertoireService.pieces
        }
        return repertoireService.pieces.filter { piece in
            piece.title.localizedCaseInsensitiveContains(searchText) ||
            piece.composer.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        Group {
            if repertoireService.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if repertoireService.pieces.isEmpty {
                Text("No pieces loaded")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredPieces) { piece in
                    NavigationLink {
                        RepertoireDetailView(piece: piece)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(piece.title)
                                .font(.headline)
                            Text(piece.composer)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .searchable(text: $searchText)
            }
        }
        .navigationTitle("Repertoire")
        .refreshable {
            await repertoireService.loadRepertoire()
        }
    }
}

#Preview {
    NavigationStack {
        RepertoireListView()
            .environmentObject(SaxRepertoireService())
    }
}
