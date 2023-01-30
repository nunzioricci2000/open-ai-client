//
//  GenerationView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 27/01/23.
//

import SwiftUI
import OpenAISwift
import UniformTypeIdentifiers

struct GenerationView: View {
    @AppStorage("token") var token: String = "No token!"
    @State var choices: [String] = []
    @State var errorMessage: String?
    @State var requestText: String = ""
    @State var fetchingData: Bool = false
    @State var lastRequestText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    TextField("Once up on a time...", text: $requestText, axis: .vertical)
                        .lineLimit(7)
                    Button {
                        Task {
                            await performRequest()
                        }
                    } label: {
                        Image(systemName: "paperplane")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(fetchingData)
                }
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                }
                Section(choices.isEmpty ? "" : "Results") {
                    ForEach(choices, id: \.self) { choice in
                        Clippable(text: "\(lastRequestText)\(choice)")
                    }
                }
            }
            .navigationTitle("Generate")
            .scrollDismissesKeyboard(.immediately)
        }
    }
}

extension GenerationView {
    func performRequest() async {
        lastRequestText = requestText
        reportStartFetching()
        do {
            set(choices: try await NetworkManager.shared.perform(request: requestText, withToken: token))
            _ = PersistencyManager.shared.save(request: requestText, response: choices)
            await UINotificationFeedbackGenerator().notificationOccurred(.success)
        } catch {
            await UINotificationFeedbackGenerator().notificationOccurred(.error)
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

struct GenerateView_Previews: PreviewProvider {
    static var previews: some View {
        GenerationView()
    }
}

private let __token = "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"
private let __token0 = "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"
