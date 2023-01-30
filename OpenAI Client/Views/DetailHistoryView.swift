//
//  DetailHistoryView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 29/01/23.
//

import SwiftUI

struct DetailHistoryView: View {
    @FetchRequest var responses: FetchedResults<Response>
    @State var request: Request
                                                    
    init(_ request: Request) {
        _request = .init(initialValue: request)
        _responses = .init(entity: Response.entity(),
                           sortDescriptors: [],
                           predicate: .init(format: "request = %@", request))
    }
    
    var body: some View {
        List {
            ForEach(responses.filter { $0.body != nil }, id: \.self) { response in
                Clippable(text: "\(request.body!)\(response.body!)")
            }
        }.navigationTitle("Responses")
    }
}

