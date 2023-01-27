//
//  GenerationView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 27/01/23.
//

import SwiftUI
import OpenAISwift

struct GenerationView: View {
    let openAi = OpenAISwift(authToken: "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")
    @State var choices: [Choice] = []
    @State var requestText: String = ""
    var body: some View {
        NavigationStack {
            List {
                TextField("Once up on a time...", text: $requestText)
                Button("Generate") {
                    openAi.sendCompletion(with: requestText) { response in
                        switch response {
                        case .success(let success):
                            choices = success.choices
                        case .failure(let failure):
                            fatalError(failure.localizedDescription)
                        }
                    }
                }
                ForEach(choices, id: \.text) { choice in
                    Text(choice.text)
                }
            }
            .listStyle(.grouped)
            .navigationTitle("OpenAI Client")
        }
    }
}

struct GenerateView_Previews: PreviewProvider {
    static var previews: some View {
        GenerationView()
    }
}
