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
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    TextField("Once up on a time...", text: $viewModel.requestText, axis: .vertical)
                        .lineLimit(7)
                    Button {
                        Task {
                            await viewModel.performRequest()
                        }
                    } label: {
                        Image(systemName: "paperplane")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.fetchingData)
                }
                Section(viewModel.choices.isEmpty ? "" : "Results") {
                    ForEach(viewModel.choices, id: \.self) { choice in
                        Text(choice).transition(.scale)
                    }
                }
            }
            .navigationTitle("Generate")
        }.onAppear {
            NetworkManager.shared.token = token
        }
    }
}

extension GenerationView {
    @MainActor
    class ViewModel: ObservableObject {
        let openAi = OpenAISwift(authToken: token)
        @Published var choices: [String] = []
        @Published var requestText: String = ""
        @Published var fetchingData: Bool = false
        
        /*
        func boh() {
            openAi.sendCompletion(with: <#T##String#>, model: <#T##OpenAIModelType#>, maxTokens: <#T##Int#>, completionHandler: <#T##(Result<OpenAI, OpenAIError>) -> Void#>)
        }
        */
        
        func performRequest() async {
            reportStartFetching()
            do {
                set(choices: try await NetworkManager.shared.perform(request: requestText))
            } catch {
                switch error {
                default: fatalError("error not handled: \(error.localizedDescription)")
                }
            }
            reportEndFetching()
        }
        
        func reportStartFetching() {
            withAnimation {
                fetchingData = true
            }
        }
        
        func reportEndFetching() {
            withAnimation {
                fetchingData = false
            }
        }
        
        func set(choices: [String]) {
            withAnimation {
                self.choices = choices
            }
        }
    }
}

struct GenerateView_Previews: PreviewProvider {
    static var previews: some View {
        GenerationView()
    }
}
