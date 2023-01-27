//
//  GenerationView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 27/01/23.
//

import SwiftUI
import OpenAISwift

let token = "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"
let token0 = "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"

struct GenerationView: View {
    let openAi = OpenAISwift(authToken: token)
    @State var choices: [Choice] = []
    @State var requestText: String = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                TextField("Once up on a time...", text: $requestText, axis: .vertical)
                    .lineLimit(7)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    Spacer()
                    Button {
                            openAi.sendCompletion(with: requestText) { response in
                                switch response {
                                case .success(let success):
                                    withAnimation {
                                        choices = success.choices
                                    }
                                case .failure(let failure):
                                    fatalError(failure.localizedDescription)
                                }
                            }
                    } label: {
                        Image(systemName: "paperplane")
                    }
                    .buttonStyle(.borderedProminent)
                }
                ForEach(choices, id: \.text) { choice in
                    Text(choice.text).transition(.push(from: .top))
                }
            }
            .padding()
            .navigationTitle("Generate")
        }
    }
}

extension GenerationView {
    class ViewModel: ObservableObject {
        
    }
}

struct GenerateView_Previews: PreviewProvider {
    static var previews: some View {
        GenerationView()
    }
}
