//
//  LengthSettingsView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI
import Combine

struct LengthSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State var length: String = ""
    @State var errorLabel: String?
    
    var body: some View {
        List {
            HStack {
                TextField("Max length", text: $length)
                    .keyboardType(.decimalPad)
                    .onReceive(Just(length)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.length = filtered
                        }
                    }
                Button("Done") {
                    saveLength()
                }
            }
            if let errorLabel = errorLabel {
                Text(errorLabel)
                    .foregroundColor(.red)
            }
        }.navigationTitle("Max Response Length")
            .scrollDismissesKeyboard(.immediately)
            .onAppear {
                do {
                    length = String(try PersistencyManager.shared.loadLength())
                } catch {
                    print(error)
                }
            }
    }
}

extension LengthSettingsView {
    func saveLength() {
        guard let length = Int(length) else {
            errorLabel = "Length MUST be a number"
            return
        }
        guard length > 0 else {
            errorLabel = "Length MUST be greater then zero"
            return
        }
        PersistencyManager.shared.save(length: length)
        dismiss()
    }
}


struct LengthSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LengthSettingsView()
    }
}
