//
//  PersistencyManager.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 27/01/23.
//

import Foundation

private let tokenKey = "token"

class PersistencyManager {
    static let shared: PersistencyManager = .init()
    private init() {}
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() throws -> String {
        guard let token = UserDefaults.standard.string(forKey: tokenKey) else {
            throw PersistencyError.tokeUnavailable
        }
        return token
    }
}

enum PersistencyError: Error {
    case tokeUnavailable
}
