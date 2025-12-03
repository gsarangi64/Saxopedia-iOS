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
    PieceRowView()
}
