//
//  NetworkManager.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 27/01/23.
//

import Foundation
import OpenAISwift

class NetworkManager {
    static var shared: NetworkManager = .init()
    private init() {}
    
    func perform(request: String, withToken token: String) async throws -> [String] {
        let openAi = OpenAISwift(authToken: token)
        let response = try await openAi.sendCompletion(with: request)
        return response.choices.map { $0.text }
    }
}

enum NetworkError: Error {
    case nilToken
}
