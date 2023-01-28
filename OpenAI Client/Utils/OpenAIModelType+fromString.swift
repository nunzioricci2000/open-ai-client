//
//  OpenAIModelType+fromString.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import OpenAISwift

extension OpenAIModelType {
    static func from(string: String) throws -> Self {
        if let gpt = Self.GPT3.init(rawValue: string) {
            return .gpt3(gpt)
        }
        if let codex = Self.Codex.init(rawValue: string) {
            return .codex(codex)
        }
        throw CustomOpenAIError.decodingError
    }
}

enum CustomOpenAIError: Error{
    case decodingError
}
