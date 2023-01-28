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
                NavigationLink(value: Page.token) {
                    HStack {
                        Image(systemName: "curlybraces")
                        Text("Token")
                        Spacer()
                        Text("sk-...MT")
                            .foregroundColor(.secondary)
                    }
                }
                NavigationLink(value: Page.engine) {
                    HStack {
                        Image(systemName: "gearshape.2")
                        Text("Engine")
                        Spacer()
                        Text("gpt davinci")
                            .foregroundColor(.secondary)
                    }
                }
                NavigationLink(value: Page.length) {
                    HStack {
                        Image(systemName: "character.cursor.ibeam")
                        Text("Max response length")
                        Spacer()
                        Text("16")
                            .foregroundColor(.secondary)
                    }
                }
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
}

extension SettingsView {
    class ViewModel: ObservableObject {
        @Published var path: [Page] = []
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
