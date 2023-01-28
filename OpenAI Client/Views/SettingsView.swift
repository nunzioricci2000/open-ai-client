//
//  SettingsView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            List {
                settingsPage("Token",
                             link: .token,
                             systemName: "curlybraces",
                             secondaryText: viewModel.tokenPreview)
                settingsPage("Engine",
                             link: .engine,
                             systemName: "gearshape.2",
                             secondaryText: viewModel.enginePreview)
                settingsPage("Max response length",
                             link: .length,
                             systemName: "character.cursor.ibeam",
                             secondaryText: viewModel.lengthPreview)
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
    class ViewModel: ObservableObject {
        @Published var path: [Page] = []
        var tokenPreview: String {
            do {
                let token = try PersistencyManager.shared.loadToken()
                let prefixEndIndex = token.index(token.startIndex, offsetBy: 3)
                let suffixStartIndex = token.index(token.endIndex, offsetBy: -2)
                let previewPrefix = token[..<prefixEndIndex]
                let previewSuffix = token[suffixStartIndex...]
                return previewPrefix + "..." + previewSuffix
            } catch {
                print(error)
            }
            return "No token!"
        }
        var enginePreview: String {
            do {
                let current = try PersistencyManager.shared.loadEngine()
                let model: String
                let engine: String
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
                return "\(model) \(engine)"
            } catch {
                print(error)
            }
            return "No engine!"
        }
        var lengthPreview: String {
            do {
                let length = try PersistencyManager.shared.loadLength()
                return "\(length)"
            } catch {
                print(error)
            }
            return "No length!"
        }
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
