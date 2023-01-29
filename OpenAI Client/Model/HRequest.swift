//
//  HRequest.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 28/01/23.
//

import Foundation

struct HRequest: Hashable, Identifiable{
    var id: UUID = .init()
    var body: String
    var time: Date
    var responses: [String]
}
