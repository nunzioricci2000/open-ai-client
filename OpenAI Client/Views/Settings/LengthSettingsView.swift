//
//  LengthSettingsView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI
import Combine

struct LengthSettingsView: View {
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            HStack {
                TextField("Max length", text: $viewModel.length)
                    .keyboardType(.decimalPad)
                    .onReceive(Just(viewModel.length)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.viewModel.length = filtered
                                    }
                                }
                Button("Done") {
                    viewModel.saveLength()
                }
            }
            if let errorLabel = viewModel.errorLabel {
                Text(errorLabel)
                    .foregroundColor(.red)
            }
        }.navigationTitle("Max Response Length")
            .onAppear {
                viewModel.dismiss = dismiss
            }
            .scrollDismissesKeyboard(.immediately)
    }
}

extension LengthSettingsView {
    class ViewModel: ObservableObject {
        @Published var length: String = ""
        @Published var errorLabel: String?
        var dismiss: DismissAction?
        
        init() {
            do {
                length = String(try PersistencyManager.shared.loadLength())
            } catch {
                print(error)
            }
        }
        
        func saveLength() {
            guard let dismiss = dismiss else {
                fatalError("dismiss not setted!")
            }
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
}


struct LengthSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LengthSettingsView()
    }
}
