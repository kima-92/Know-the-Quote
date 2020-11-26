//
//  QuizController.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation
import CoreData
import Firebase

class QuizController {
    
    // MARK: - Properties
    
    private let baseURL = URL(string: "https://know-the-quote.firebaseio.com/")!
    let db = Firestore.firestore()
    
    var user: User?
    var quiz: Quiz?
    var title: String?
    var creator: User?
    
    // Max / Min
    let quoteCountMin = 0
    let quoteCountMax = 15
    let currentQuoteMinIndex = 1
    let currentQuoteMaxIndex = 14
    let quizMinQuotes = 3
    let quizMaxQuotes = 15
    
    // Counters and cache
    var currentQuote = 1
    var quotes: [Int : Quote] = [:]
    
    // MARK: - Shared Methods
    
    private func resetCounter() {
        currentQuote = 1
    }
    
    private func resetQuotesDictionary() {
        quotes = [:]
    }
    
    // MARK: - NewQuizVC Methods
    
    // Check if there's enough quotes to create a quiz
    func quizCanBeSaved() -> Bool {
        if quotes.count <= quizMaxQuotes && quotes.count >= quizMinQuotes { return true }
        return false
    }
    
    // Check if currentQuote can move Prev/Next
    func canMoveToNext() -> Bool {
        if quotes.count <= quoteCountMax && currentQuote <= currentQuoteMaxIndex { return true }
        return false
    }
    func canMoveToPrev() -> Bool {
        if quotes.count != quoteCountMin && currentQuote > currentQuoteMinIndex { return true }
        return false
    }
    
    // Move currentQuote Prev/Next
    func moveToNextQuote() {
        if canMoveToNext() { currentQuote += 1 }
    }
    func moveToPrevQuote() {
        if canMoveToPrev() { currentQuote -= 1 }
    }
    
    // MARK: - QuizVC Methods
    
    // Setup to start a quiz
    func setupStart(quiz: Quiz) -> Quote? {
        resetCounter()
        resetQuotesDictionary()
        
        // Fetch all quotes
        getAllQuotesOf(quiz: quiz)
        
        resetCounter()
        
        // Return the first quote
        return quotes[currentQuote]
    }
    
    // Return the next quote that needs to be displayed
    func nextQuoteToDisplay() -> Quote? {
        if currentQuote < quotes.count {
            
            currentQuote += 1
            return quotes[currentQuote]
        }
        return nil
    }
    
    // MARK: - Firebase
    
    // Save Quiz in Firebase
    func put(quiz: Quiz, creatorID: UUID, completion: @escaping (Result<QuizRepresentation?, NetworkingError>) -> Void) {
        
        guard let quizRep = quiz.quizRepresentation else { return completion(.failure(.noRepresentation))}
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent(creatorID.uuidString)
            .appendingPathComponent("quizzesCreated")
            .appendingPathComponent(quizRep.id.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(quizRep)
            completion(.success(quizRep))
        } catch {
            NSLog("Error encoding quizRepresentation: \(error)")
            completion(.failure(.badEncode))
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error PUTting quiz: \(error)")
                completion(.failure(.notAddedToFirebase))
                return
                // TODO: - Alert the user
            }
            
            if (response as? HTTPURLResponse) != nil {
                // TODO: - Handle response | response.statusCode
            }
        }.resume()
    }
    
    // Save a Quote in Firebase
    func put(quote: Quote, quizID: UUID, creatorID: UUID, completion: @escaping (Result<QuoteRepresentation?, NetworkingError>) -> Void) {
        
        guard let quoteRep = quote.quoteRepresentation else { return }
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent(creatorID.uuidString)
            .appendingPathComponent("quizzesCreated")
            .appendingPathComponent(quizID.uuidString)
            .appendingPathComponent("quotes")
            .appendingPathComponent(quoteRep.quoteID)
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
    
    // Save new User in Firebase
    func put(user: User, completion: @escaping (Result<UserRepresentation?, NetworkingError>) -> Void) {
        
        guard let userRep = user.userRepresentation,
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
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent(username)
        
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
                    
                    if let user = self.getUserFromCD(userID: userRep.id.uuidString) {
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
    
    // Create new Quiz
    // Save in CD/FB WITHOUT any quotes
    func createUser(username: String, password: String, context: NSManagedObjectContext) -> User? {
        
        user = User(username: username, password: password, context: context)
        guard let user = user else { return nil }
        
        put(user: user) { (result) in
            
            do {
                _ = try result.get()
                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Couldn't save new user on server: \(error)")
            }
        }
        return user
    }
    
    // Create new Quiz and save in CD WITHOUT any quotes
    func createEmptyQuiz(context: NSManagedObjectContext) {
        guard let title = title,
              let creator = creator,
              let creatorID = creator.id  else { return }
        
        quiz = Quiz(title: title, creator: creator, context: context)
        guard let quiz = quiz else { return }
        
        creator.addToQuizzesCreated(quiz)
        put(quiz: quiz, creatorID: creatorID) { (result) in
            
            do {
                _ = try result.get()
                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Couldn't save new quiz on server: \(error)")
            }
        }
    }
    
    // Add a new quote to the quiz
    func createQuote(firstPart: String?, secondPart: String?, answer: String, incorrectAnswers: [String], context: NSManagedObjectContext) {
        guard let quiz = quiz,
              let creator = creator,
              let creatorID = creator.id,
              let quizID = quiz.id else { return }
        
        // If there's less than 16 quotes in the array, create this new quote and add it to the quiz
        if quotes.count < 16 {
            
            let quote = Quote(quizID: quizID.uuidString, firstPart: firstPart ?? "", secondPart: secondPart ?? "", incorrectOptions: incorrectAnswers, answer: answer, context: context)
            
            put(quote: quote, quizID: quizID, creatorID: creatorID) { (result) in
                
                do {
                    _ = try result.get()
                    self.quotes[self.quotes.count + 1] = quote
                    quiz.addToQuotes(quote)
                    CoreDataStack.shared.save(context: context)
                } catch {
                    NSLog("Failed to save Quote in Firebase \(error)")
                    // TODO: - Alert User
                }
            }
        } else {
            // TODO: - Alert the user they can't create a Quiz with more than 15 Quotes
        }
    }
    
    // Fetch quotes of a specific quiz from CoreData
    func getAllQuotesOf(quiz: Quiz) {
        
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
        } catch {
            NSLog("Could not fetch quotes")
            // TODO: - Alert the user
        }
    }
    
    // Fetch All Users from CoreData
    func getAllUsersFromCD() -> [User]? {
        
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do {
            let users = try moc.fetch(fetchRequest)
            return users
        } catch {
            NSLog("Could not fetch users")
            return nil
            // TODO: - Alert the user
        }
    }
    
    // Fetch a User from CoreData
    func getUserFromCD(userID: String) -> User? {
        
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id", userID)
        
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
