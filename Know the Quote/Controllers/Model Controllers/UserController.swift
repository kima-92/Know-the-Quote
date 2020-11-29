//
//  UserController.swift
//  Know the Quote
//
//  Created by macbook on 11/28/20.
//

import Foundation
import CoreData
import Firebase

class UserController {
    
    // MARK: - Properties
    
    var baseURL: URL?
    var db: Firestore?
    var user: User?
    
    // MARK: - Init
    
    init(baseURL: URL, db: Firestore) {
        self.baseURL = baseURL
        self.db = db
    }
    
    // MARK: - Firebase
    
    // Save new User in Firebase
    private func put(user: User, completion: @escaping (Result<UserRepresentation?, NetworkingError>) -> Void) {
        
        guard let baseURL = baseURL,
              let userRep = user.userRepresentation,
              let username = user.username else { return completion(.failure(.noRepresentation))}
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent(username)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(userRep)
            completion(.success(userRep))
        } catch {
            NSLog("Error encoding new user: \(error)")
            completion(.failure(.badEncode))
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error PUTting new user: \(error)")
                completion(.failure(.notAddedToFirebase))
                return
                // TODO: - Alert the user
            }
            
            if (response as? HTTPURLResponse) != nil {
                // TODO: - Handle response | response.statusCode
            }
        }.resume()
    }
    
    // Fetch User from Firebase
    func fetch(username: String, password: String, completion: @escaping (Result<User?, NetworkingError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.noBaseURL))}
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent(username)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Failed to fetch user: \(error)")
                completion(.failure(.noData))
            }
            
            if let data = data {
                // Decode then fetch from/create user in CoreData
                do {
                    let userRep = try JSONDecoder().decode(UserRepresentation.self, from: data)
                    
                    if let user = self.getUserFromCD(username: userRep.username) {
                        self.user = user
                        completion(.success(self.user))
                    } else {
                        let moc = CoreDataStack.shared.mainContext
                        self.user = User(username: username, password: password, context: CoreDataStack.shared.mainContext)
                        CoreDataStack.shared.save(context: moc)
                        completion(.success(self.user))
                    }
                } catch {
                    NSLog("Failed to fetch/decode user: \(error)")
                    completion(.failure(.badDecode))
                    // TODO: - Alert User
                }
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                completion(.failure(.unexpectedStatusCode(response.statusCode)))
            }
        }.resume()
    }
    
    // MARK: - CoreData
    
    // Create new User in CD & FB
    func createUser(username: String, password: String, context: NSManagedObjectContext) -> User? {
        
        user = User(username: username, password: password, context: context)
        guard let user = user else { return nil }
        
        put(user: user) { (result) in
            
            do {
                _ = try result.get()
                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Couldn't save new user on server: \(error)")
                // TODO: - Alert user
            }
        }
        return user
    }
    
    // Fetch a User from CoreData
    func getUserFromCD(username: String) -> User? {
        
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let users = try moc.fetch(fetchRequest)
            let user = users.first
            return user
        } catch {
            NSLog("Could not fetch user fro FB")
            return nil
            // TODO: - Alert the user
        }
    }
}
