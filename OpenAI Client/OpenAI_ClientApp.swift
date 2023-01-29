//
//  OpenAI_ClientApp.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 27/01/23.
//

import SwiftUI

@main
struct OpenAI_ClientApp: App {
    @State var persistencyManager: PersistencyManager = .shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistencyManager.persistentContainer.viewContext)
        }
    }
}
