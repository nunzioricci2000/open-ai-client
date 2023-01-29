//
//  HistoryView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI

struct HistoryView: View {
    var requests: [HRequest] {
        PersistencyManager.shared.loadRequests()
    }
    @State var searchField: String = ""
    @State var path: [HRequest] = []
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if requests.isEmpty {
                    Text("Your requests will be added here in the future")
                        .foregroundColor(.secondary)
                }
                ForEach(requests) { request in
                    NavigationLink(value: request) {
                        Text("\( request.body )...")
                    }
                }
            }.navigationTitle("History")
                .searchable(text: $searchField)
                .navigationDestination(for: HRequest.self) { request in
                    List {
                        ForEach(request.responses, id: \.self) { response in
                            Text("**\(request.body)**\n\(response.trimmingCharacters(in: .whitespacesAndNewlines))")
                        }
                    }
                }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
