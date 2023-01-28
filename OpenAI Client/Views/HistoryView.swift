//
//  HistoryView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI

struct HistoryView: View {
    @State var requests: [String] = []
    @State var searchField: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                if requests.isEmpty {
                    Text("Your requests will be added here in the future")
                        .foregroundColor(.secondary)
                }
            }.navigationTitle("History")
                .searchable(text: $searchField)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
