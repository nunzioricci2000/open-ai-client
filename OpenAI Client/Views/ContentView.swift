//
//  ContentView.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 27/01/23.
//

import SwiftUI
import OpenAISwift

struct ContentView: View {
    var body: some View {
        TabView {
            GenerationView()
                .tabItem {
                    Label("Generete", systemImage: "terminal")
                }
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "list.bullet")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
