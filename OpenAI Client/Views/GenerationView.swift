//
//  GenerationView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 27/01/23.
//

import SwiftUI
import OpenAISwift

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
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
                Section(viewModel.choices.isEmpty ? "" : "Results") {
                    ForEach(viewModel.choices, id: \.self) { choice in
                        Text(choice).transition(.scale)
                    }
                }
            }
            .navigationTitle("Generate")
        }
    }
}

extension GenerationView {
    @MainActor
    class ViewModel: ObservableObject {
        var token: String {
            (try? PersistencyManager.shared.loadToken()) ?? ""
        }
        @Published var choices: [String] = []
        @Published var errorMessage: String?
        @Published var requestText: String = ""
        @Published var fetchingData: Bool = false
        
        func performRequest() async {
            reportStartFetching()
            do {
                set(choices: try await NetworkManager.shared.perform(request: requestText, withToken: token))
            } catch {
                switch error {
                case OpenAIError.genericError(let nestedError):
                    errorMessage = nestedError.localizedDescription
                case OpenAIError.decodingError(let nestedError):
                    errorMessage = nestedError.localizedDescription
                default: fatalError("error not handled: \(error.localizedDescription)")
                }
            }
            reportEndFetching()
        }
        
        func reportStartFetching() {
            withAnimation {
                errorMessage = nil
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

private let __token = "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"
private let __token0 = "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"
