//
//  TokenSettingsView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI

struct TokenSettingsView: View {
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            HStack {
                TextField("Your token here", text: $viewModel.token)
                Button("Done") {
                    viewModel.saveToken()
                }
            }
            if let errorLabel = viewModel.errorLabel {
                Text(errorLabel)
                    .foregroundColor(.red)
            }
        }.navigationTitle("Token")
            .onAppear {
                viewModel.dismiss = dismiss
            }
            .scrollDismissesKeyboard(.immediately)
    }
}

extension TokenSettingsView {
    class ViewModel: ObservableObject {
        @Published var token: String = ""
        @Published var errorLabel: String?
        var dismiss: DismissAction?
        
        func saveToken() {
            guard let dismiss = dismiss else {
                fatalError("dismiss not setted!")
            }
            guard token.hasPrefix("sk-") else {
                errorLabel = "token not valid!"
                return
            }
            PersistencyManager.shared.save(token: token)
            dismiss()
        }
    }
}

struct TokenSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TokenSettingsView()
        }
    }
}
