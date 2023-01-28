//
//  PersistencyManager.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 27/01/23.
//

import Foundation
import OpenAISwift

class PersistencyManager {
    static let shared: PersistencyManager = .init()
    private init() {}
    
    func save(token: String) {
        UserDefaults.standard.set(token, forKey: SettingsKey.token.rawValue)
    }
    
    func loadToken() throws -> String {
        let key = SettingsKey.token
        guard let token = UserDefaults.standard.string(forKey: key.rawValue) else {
            throw PersistencyError.keyUnavailable(key)
        }
        return token
    }
    
    func save(engine: OpenAIModelType) {
        UserDefaults.standard.set(engine.modelName, forKey: SettingsKey.engine.rawValue)
    }
    
    func loadEngine() throws -> OpenAIModelType {
        let key = SettingsKey.engine
        guard let engineString = UserDefaults.standard.string(forKey: key.rawValue) else {
            throw PersistencyError.keyUnavailable(key)
        }
        return try OpenAIModelType.from(string: engineString)
    }
    
    func save(length: Int) {
        UserDefaults.standard.set(length, forKey: SettingsKey.length.rawValue)
    }
    
    func loadLength() throws -> Int {
        let key = SettingsKey.length
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
}

enum SettingsKey: String {
    case token = "token"
    case engine = "engine"
    case length = "length"
}


enum PersistencyError: Error {
    case keyUnavailable(SettingsKey)
}
