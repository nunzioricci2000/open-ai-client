//
//  SettingsView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI
import OpenAISwift

struct SettingsView: View {
    @AppStorage("token") var token: String = "No token!"
    @AppStorage("engine") var engine: String = OpenAIModelType.gpt3(.davinci).modelName
    @AppStorage("length") var length: Int = 16
    @State var path: [Page] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                settingsPage("Token",
                             link: .token,
                             systemName: "curlybraces",
                             secondaryText: tokenPreview)
                settingsPage("Engine",
                             link: .engine,
                             systemName: "gearshape.2",
                             secondaryText: enginePreview)
                settingsPage("Max response length",
                             link: .length,
                             systemName: "character.cursor.ibeam",
                             secondaryText: lengthPreview)
            }
            .navigationTitle("Settings")
            .navigationDestination(for: Page.self) { page in
                switch page {
                case .token: TokenSettingsView()
                case .engine: EngineSettingsView()
                case .length: LengthSettingsView()
                }
            }
        }
    }
    
    @ViewBuilder
    func settingsPage(_ title: String, link: Page, systemName: String?, secondaryText: String?) -> some View {
        NavigationLink(value: link) {
            HStack {
                if let systemName = systemName {
                    Image(systemName: systemName)
                        .frame(width: 22)
                }
                Text(title)
                if let secondaryText = secondaryText {
                    Spacer()
                    Text(secondaryText)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

extension SettingsView {
    var tokenPreview: String {
        let prefixEndIndex = token.index(token.startIndex, offsetBy: 3)
        let suffixStartIndex = token.index(token.endIndex, offsetBy: -2)
        let previewPrefix = token[..<prefixEndIndex]
        let previewSuffix = token[suffixStartIndex...]
        return String(previewPrefix + "..." + previewSuffix)
    }
    
    var enginePreview: String {
        let current = engine
        let model: String
        let engine: String
        switch current {
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
            fatalError("Unknown engine: \(current)")
        }
        return "\(model) \(engine)"
    }
    
    var lengthPreview: String {
        return "\(length)"
    }
    
    enum Page {
        case token
        case engine
        case length
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
