//
//  EngineSettingsView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI
import OpenAISwift

struct EngineSettingsView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            Section("Model") {
                selectableModel(title: "GPT3")
                selectableModel(title: "Codex")
            }
            Section("Engine") {
                if viewModel.model == "GPT3" {
                    selectableEngine(title: "Ada")
                    selectableEngine(title: "Babbage")
                    selectableEngine(title: "Curie")
                    selectableEngine(title: "Davinci")
                } else if viewModel.model == "Codex" {
                    selectableEngine(title: "Cushman")
                    selectableEngine(title: "Davinci")
                } else {
                    fatalError("unknown model: \(viewModel.model)")
                }
            }
        }.navigationTitle("Engine")
    }
    
    @ViewBuilder
    func selectableModel(title: String) -> some View {
        let selected = title == viewModel.model
        selectable(title: title, selected: selected) {
            viewModel.model = title
            viewModel.engine = "Davinci"
            viewModel.save()
        }
    }
    
    @ViewBuilder
    func selectableEngine(title: String) -> some View {
        let selected = title == viewModel.engine
        selectable(title: title, selected: selected) {
            viewModel.engine = title
            viewModel.save()
        }
    }
    
    @ViewBuilder
    func selectable(title: String, selected: Bool, onClick: @escaping () -> ()) -> some View {
        Button {
            onClick()
        } label: {
            HStack {
                Text(title)
                Spacer()
                if selected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.secondary)
                }
            }.foregroundColor(.primary)
        }
    }
}

extension EngineSettingsView {
    class ViewModel: ObservableObject {
        @Published var model: String = "GPT3"
        @Published var engine: String = "Davinci"
        
        init() {
            do {
                try load()
            } catch {
                print(error)
            }
        }
        
        func load() throws {
            let current = try PersistencyManager.shared.loadEngine()
            switch current {
            case .gpt3(.ada):
                model = "GPT3"
                engine = "Ada"
            case .gpt3(.babbage):
                model = "GPT3"
                engine = "Babbage"
            case .gpt3(.curie):
                model = "GPT3"
                engine = "Curie"
            case .gpt3(.davinci):
                model = "GPT3"
                engine = "Davinci"
            case .codex(.cushman):
                model = "Codex"
                engine = "Cushman"
            case .codex(.davinci):
                model = "Codex"
                engine = "Davinci"
            }
        }
        
        func save() {
            let result: OpenAIModelType
            switch model {
            case "GPT3":
                switch engine {
                case "Ada": result = .gpt3(.ada)
                case "Babbage": result = .gpt3(.babbage)
                case "Curie": result = .gpt3(.curie)
                case "Davinci": result = .gpt3(.davinci)
                default: fatalError("Unknown GPT3 model: \(engine)")
                }
            case "Codex":
                switch engine {
                case "Cushman": result = .codex(.cushman)
                case "Davinci": result = .codex(.davinci)
                default: fatalError("Unknown Codex model: \(engine)")
                }
            default: fatalError("Unknown engine: \(model)")
            }
            PersistencyManager.shared.save(engine: result)
        }
    }
}

struct EngineSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        EngineSettingsView()
    }
}
