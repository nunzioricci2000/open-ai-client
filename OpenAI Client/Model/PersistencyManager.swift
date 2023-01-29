//
//  PersistencyManager.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 27/01/23.
//

import Foundation
import OpenAISwift
import CoreData

class PersistencyManager {
    static let shared: PersistencyManager = .init()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(request body: String, response: [String]) -> Request {
        let request = Request(context: persistentContainer.viewContext)
        request.body = body
        request.date = Date()
        for body in response {
            let response = save(response: body)
            request.addToResponse(response)
        }
        save()
        return request
    }
    
    func loadRequests() -> [HRequest] {
        let dataRequest: NSFetchRequest<Request> = Request.fetchRequest()
        guard let requests = try? persistentContainer.viewContext.fetch(dataRequest) else {
            return []
        }
        var result = [HRequest]()
        for request in requests.filter({ $0.body != nil }) {
            var record: HRequest = .init(body: "", time: .distantPast, responses: [])
            record.body = request.body!
            record.time = request.date ?? .now
            record.responses = loadResponses(request)
            result.append(record)
        }
        return result
    }
    
    func save(response body: String) -> Response {
        let response = Response(context: persistentContainer.viewContext)
        response.body = body
        save()
        return response
    }
    
    func loadResponses(_ request: Request) -> [String] {
        let fetchRequest: NSFetchRequest<Response> = Response.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "request = %@", request)
        var fetchedResponses: [Response] = []
        do {
          fetchedResponses = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
          print("Error fetching songs \(error)")
        }
        return fetchedResponses.filter { $0.body != nil }.map { $0.body! }
    }
    
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
