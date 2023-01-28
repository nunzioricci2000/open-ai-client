//
//  LengthSettingsView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI

struct LengthSettingsView: View {
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    var body: some View {
        List {
            HStack {
                TextField("16", value: $viewModel.length, formatter: formatter)
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
    }
}

extension LengthSettingsView {
    class ViewModel: ObservableObject {
        @Published var length: Int = 16
        @Published var errorLabel: String?
        var dismiss: DismissAction?
        
        init() {
            do {
                length = try PersistencyManager.shared.loadLength()
            } catch {
                print(error)
            }
        }
        
        func saveLength() {
            guard let dismiss = dismiss else {
                fatalError("dismiss not setted!")
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
