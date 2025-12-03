//
//  PieceRowView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct PieceRowView: View {
    let piece: SaxPiece

    var body: some View {
        VStack(alignment: .leading) {
            Text(piece.title).font(.headline)
            Text(piece.composer).font(.subheadline)
        }
    }
}

#Preview {
    PieceRowView(piece: SaxPiece(
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
    .previewLayout(.sizeThatFits)
    .padding()
}
