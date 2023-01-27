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
                    Image(systemName: "terminal")
                    Text("Generete")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
