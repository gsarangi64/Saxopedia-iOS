//
//  RepertoireListView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct RepertoireListView: View {
    @EnvironmentObject var service: SaxRepertoireService

    var body: some View {
        List {
            if service.pieces.isEmpty {
                ProgressView("Loading repertoire…")
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(service.pieces) { piece in
                    NavigationLink {
                        RepertoireDetailView(piece: piece)
                    } label: {
                        PieceRowView(piece: piece)
                    }
                }
            }
        }
        .navigationTitle("Repertoire")
        .task {
            await service.fetchRepertoire()
        }
    }
}

#Preview {
    // Provide a dummy service for preview
    RepertoireListView()
        .environmentObject(SaxRepertoireService())
}
