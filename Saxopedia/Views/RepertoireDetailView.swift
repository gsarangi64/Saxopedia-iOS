//
//  RepertoireDetailView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct RepertoireDetailView: View {
    let piece: SaxPiece

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(piece.title).font(.title)
                Text(piece.composer).font(.headline)
                Text("Year: \(piece.year)")
                Text("Instrumentation: \(piece.instrumentation)")
                Text("Difficulty: \(piece.difficulty)")
                Text("Duration: \(piece.duration)")
                Text("Publisher: \(piece.publisher)")
                if !piece.notes.isEmpty {
                    Text("Notes: \(piece.notes)")
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle(piece.title)
    }
}

#Preview {
    RepertoireDetailView(piece: SaxPiece(
        title: "Sonata for Alto Saxophone",
        composer: "Paul Creston",
        year: 1944,
        instrumentation: "Alto Sax & Piano",
        difficulty: "Advanced",
        duration: "12 min",
        publisher: "Belwin",
        recording_url: "",
        notes: "Classic mid-20th century sonata."
    ))
}
