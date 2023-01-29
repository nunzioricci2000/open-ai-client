//
//  EngineSettingsView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI
import OpenAISwift

struct EngineSettingsView: View {
    @AppStorage("engine") var _saved: String = OpenAIModelType.gpt3(.davinci).modelName
    
    var body: some View {
        List {
            Section("Model") {
                selectableModel(title: "GPT3")
                selectableModel(title: "Codex")
            }
            Section("Engine") {
                if model == "GPT3" {
                    selectableEngine(title: "Ada")
                    selectableEngine(title: "Babbage")
                    selectableEngine(title: "Curie")
                    selectableEngine(title: "Davinci")
                } else if model == "Codex" {
                    selectableEngine(title: "Cushman")
                    selectableEngine(title: "Davinci")
                } else {
                    fatalError("unknown model: \(model)")
                }
            }
        }.navigationTitle("Engine")
    }
    
    @ViewBuilder
    func selectableModel(title: String) -> some View {
        let selected = title == model
        selectable(title: title, selected: selected) {
            engine = "Davinci"
            model = title
        }
    }
    
    @ViewBuilder
    func selectableEngine(title: String) -> some View {
        let selected = title == engine
        selectable(title: title, selected: selected) {
            engine = title
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
    var modelEngine: (String, String) {
        get { load() ?? ("GPT3", "Davinci") }
        nonmutating set { save(model: newValue.0, engine: newValue.1) }
    }
    
    var model: String {
        get { modelEngine.0 }
        nonmutating set { modelEngine.0 = newValue }
    }
    
    var engine: String {
        get { modelEngine.1 }
        nonmutating set { modelEngine.1 = newValue }
    }
    
    func load() -> (String, String)? {
        let model: String
        let engine: String
        switch _saved {
        case OpenAIModelType.gpt3(.ada).modelName:
            model = "GPT3"
            engine = "Ada"
        case OpenAIModelType.gpt3(.babbage).modelName:
            model = "GPT3"
            engine = "Babbage"
        case OpenAIModelType.gpt3(.curie).modelName:
            model = "GPT3"
            engine = "Curie"
        case OpenAIModelType.gpt3(.davinci).modelName:
            model = "GPT3"
            engine = "Davinci"
        case OpenAIModelType.codex(.cushman).modelName:
            model = "Codex"
            engine = "Cushman"
        case OpenAIModelType.codex(.davinci).modelName:
            model = "Codex"
            engine = "Davinci"
        default:
            return nil
        }
        return (model, engine)
    }
    
    func save(model: String, engine: String) {
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
        _saved = result.modelName
    }
}

struct EngineSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        EngineSettingsView()
    }
}
