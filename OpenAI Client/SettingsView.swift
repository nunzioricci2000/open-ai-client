//
//  SettingsView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import SwiftUI

struct SettingsView: View {
    @State var path: [SettingsPage] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                NavigationLink(value: SettingsPage.token) {
                    HStack {
                        Image(systemName: "curlybraces")
                        Text("Token")
                        Spacer()
                        Text("sk-...MT")
                            .foregroundColor(.secondary)
                    }
                }
                NavigationLink(value: SettingsPage.engine) {
                    HStack {
                        Image(systemName: "gearshape.2")
                        Text("Engine")
                        Spacer()
                        Text("gpt davinci")
                            .foregroundColor(.secondary)
                    }
                }
                NavigationLink(value: SettingsPage.lengh) {
                    HStack {
                        Image(systemName: "character.cursor.ibeam")
                        Text("Max response lengh")
                        Spacer()
                        Text("16")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationDestination(for: SettingsPage.self) { page in
                Color.blue
            }
        }
    }
}

enum SettingsPage {
    case token
    case engine
    case lengh
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
