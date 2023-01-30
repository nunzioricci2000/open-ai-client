//
//  ListHistoryView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 29/01/23.
//

import SwiftUI

struct ListHistoryView: View {
    @FetchRequest var requests: FetchedResults<Request>
    
    init(filteredBy filter: String?) {
        if let filter = filter {
            _requests = .init(entity: Request.entity(), sortDescriptors: [], predicate: .init(format: "body CONTAINS[cd] %@", filter))
        } else {
            _requests = .init(entity: Request.entity(), sortDescriptors: [])
        }
    }
    
    var body: some View {
        ForEach(requests) { request in
            NavigationLink(value: request) {
                VStack {
                    Text(request.body! + "...")
                }.foregroundColor(.primary)
            }
        }
    }
}
