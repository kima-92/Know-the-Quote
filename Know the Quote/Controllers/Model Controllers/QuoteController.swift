//
//  QuoteController.swift
//  Know the Quote
//
//  Created by macbook on 11/28/20.
//

import Foundation
import Firebase
import CoreData

class QuoteController {
    
    // MARK: - Properties
    
    var baseURL: URL?
    var db: Firestore?
    var user: User?
    
    var quotes: [Int : Quote] = [:]
    var currentQuote = 1
    
    // MARK: - Init
    
    init(baseURL: URL, db: Firestore) {
        self.baseURL = baseURL
        self.db = db
    }
    
    // MARK: - Firebase
    
    // Save a Quote in User's account - Firebase
    func putQuoteForUser(quote: Quote, quizID: UUID, completion: @escaping (Result<QuoteRepresentation?, NetworkingError>) -> Void) {
        
        guard let baseURL = baseURL,
              let quoteRep = quote.quoteRepresentation,
              let creator = user,
              let creatorUsername = creator.username else { return completion(.failure(.noRepresentation)) }
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent(creatorUsername)
            .appendingPathComponent("quizzesCreated")
            .appendingPathComponent(quizID.uuidString)
            .appendingPathComponent("quotes")
            .appendingPathComponent(quoteRep.quoteID.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(quoteRep)
            completion(.success(quoteRep))
        } catch {
            NSLog("Error encoding quote: \(error)")
            completion(.failure(.badEncode))
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error PUTting quote: \(error)")
                completion(.failure(.notAddedToFirebase))
                return
                // TODO: - Alert the user
            }
            
            if (response as? HTTPURLResponse) != nil {
                // TODO: - Handle response | response.statusCode
            }
        }.resume()
    }
    
    // Save a Quote in categorized Quizzes - Firebase
    func putForQuizBy(categoryName: String, quote: Quote, quizID: UUID, completion: @escaping (Result<QuoteRepresentation?, NetworkingError>) -> Void) {
        
        guard let baseURL = baseURL,
              let quoteRep = quote.quoteRepresentation else { return completion(.failure(.noRepresentation)) }
        
        let requestURL = baseURL
            .appendingPathComponent("categories")
            .appendingPathComponent(categoryName)
            .appendingPathComponent("quizzes")
            .appendingPathComponent(quizID.uuidString)
            .appendingPathComponent("quotes")
            .appendingPathComponent(quoteRep.quoteID.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(quoteRep)
            completion(.success(quoteRep))
        } catch {
            NSLog("Error encoding quote: \(error)")
            completion(.failure(.badEncode))
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error PUTting quote: \(error)")
                completion(.failure(.notAddedToFirebase))
                return
                // TODO: - Alert the user
            }
            
            if (response as? HTTPURLResponse) != nil {
                // TODO: - Handle response | response.statusCode
            }
        }.resume()
    }
    
    // MARK: - CoreData
    
    // Fetch quotes of a specific quiz from CoreData
    func getAllQuotesOf(quiz: Quiz) -> [Int : Quote]? {
        
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest = NSFetchRequest<Quote>(entityName: "Quote")
        
        if let quizIDString = quiz.id?.uuidString {
            fetchRequest.predicate = NSPredicate(format: "quizID == %@", quizIDString)
        }
        
        do {
            let quotes = try moc.fetch(fetchRequest)
            
            // Store each quote in the dictionary
            for quote in quotes {
                self.quotes[currentQuote] = quote
                currentQuote += 1
            }
            return self.quotes
        } catch {
            NSLog("Could not fetch quotes")
            // TODO: - Alert the user
            return nil
        }
    }
}
