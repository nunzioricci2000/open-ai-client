//
//  HistoryView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @FetchRequest(entity: Request.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "date",
                                                     ascending: false )])
    var requests: FetchedResults<Request>
    @State var searchField: String = ""
    @State var path: [Request] = []
    // @FetchRequest(entity: Request.entity(), sortDescriptors: [], predicate: .init(format: "body CONTAINS[cd] %@", searchField))
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if requests.isEmpty {
                    Text("Your requests will be added here in the future")
                        .foregroundColor(.secondary)
                }
                ForEach(requests.filter { $0.body != nil ? searchField != "" ? $0.body!.lowercased().contains(searchField.lowercased()) : true : false }) { request in
                    NavigationLink(value: request) {
                        Text("\( request.body! )...")
                    }
                }
            }.navigationTitle("History")
                .searchable(text: $searchField) /* {
                    ListHistoryView(filteredBy: searchField)
                }*/
                .navigationDestination(for: Request.self) { request in
                    info(for: request)
                }
        }
    }
    
    func info(for request: Request) -> some View {
        DetailHistoryView(request)
    }
}

extension HistoryView {
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
