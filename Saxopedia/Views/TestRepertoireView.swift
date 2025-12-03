//
//  TestRepertoireView.swift
//  Saxopedia
//
//  Created by Sarangi, Gaurav on 12/3/25.
//

import SwiftUI

struct TestRepertoireView: View {
    @StateObject private var service = SaxRepertoireService()

    var body: some View {
        VStack {
            if service.pieces.isEmpty {
                ProgressView("Loading repertoire…")
            } else {
                List(service.pieces) { piece in
                    VStack(alignment: .leading) {
                        Text(piece.title)
                            .font(.headline)
                        Text(piece.composer)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .task {
            await service.fetchRepertoire()
        }
    }
}

struct TestRepertoireView_Previews: PreviewProvider {
    static var previews: some View {
        TestRepertoireView()
    }
}
