//
//  TokenSettingsView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI

struct TokenSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("token") var token: String = ""
    @State var errorLabel: String?
    @State var text: String = ""
    
    var body: some View {
        List {
            HStack {
                TextField("Your token here", text: $text)
                Button("Done") {
                    saveToken()
                }
            }
            if let errorLabel = errorLabel {
                Text(errorLabel)
                    .foregroundColor(.red)
            }
        }.navigationTitle("Token")
            .scrollDismissesKeyboard(.immediately)
    }
}

extension TokenSettingsView {
    func saveToken() {
        guard text.hasPrefix("sk-") else {
            errorLabel = "token not valid!"
            return
        }
        token = text
        dismiss()
    }
}

struct TokenSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TokenSettingsView()
        }
    }
}
