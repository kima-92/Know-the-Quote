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
    
    var baseURL: URL?
    var db: Firestore?
    var user: User?
    var quoteController: QuoteController
    
    var quiz: Quiz?
    var title: String?
    var quizzes: [Quiz]?
    var categoryStrings: [String]?
    
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
    
    // MARK: - Init
    
    init(baseURL: URL, db: Firestore) {
        self.baseURL = baseURL
        self.db = db
        self.quoteController = QuoteController(baseURL: baseURL, db: db)
    }
    
    // MARK: - Shared VCs Methods
    
    private func syncUser() {
        if quoteController.user != self.user {
            quoteController.user = self.user
        }
    }
    
    private func resetCounter() {
        currentQuote = 1
        quoteController.currentQuote = self.currentQuote
    }
    
    private func resetQuotesDictionary() {
        quotes = [:]
        quoteController.quotes = self.quotes
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
        syncUser()
        
        // Fetch all quotes
        if let quotes = quoteController.getAllQuotesOf(quiz: quiz) {
            self.quotes = quotes
        }
        
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
    
    // Save Quiz under user's createdQuizzes in Firebase
    func put(quiz: Quiz, completion: @escaping (Result<QuizRepresentation?, NetworkingError>) -> Void) {
        
        guard let baseURL = baseURL,
              let quizRep = quiz.quizRepresentation,
              let creator = user,
              let creatorUsername = creator.username else { return completion(.failure(.noRepresentation)) }
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent(creatorUsername)
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
    
    // Save new Category -> Firebase
    private func createNew(category: String, completion: @escaping (Result<Category?, NetworkingError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.noBaseURL)) }
        
        let cat = Category(name: category, quizzes: [])
        categoryStrings?.append(category)
        
        let requestURL = baseURL
            .appendingPathComponent("categories")
            .appendingPathComponent(category)
//            .appendingPathComponent(quizRep.id.uuidString)
//            .appendingPathComponent("quizzes")
//            .appendingPathComponent(quizRep.id.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(cat)
//            completion(.success(cat))
        } catch {
            NSLog("Error encoding category: \(error)")
            completion(.failure(.badEncode))
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error PUTting empty category: \(error)")
                completion(.failure(.notAddedToFirebase))
                return
                // TODO: - Alert the user
            }
            
            if (response as? HTTPURLResponse) != nil {
                // TODO: - Handle response | response.statusCode
            }
            completion(.success(cat))
        }.resume()
    }
    
    // Add Quiz in category -> Firebase
    private func putInCategory(quiz: Quiz, category: String, completion: @escaping (Result<QuizRepresentation?, NetworkingError>) -> Void) {
        
        guard let baseURL = baseURL,
              let quizRep = quiz.quizRepresentation else { return completion(.failure(.noRepresentation)) }
        
        let requestURL = baseURL
            .appendingPathComponent("categories")
            .appendingPathComponent(category)
//            .appendingPathComponent(quizRep.id.uuidString)
            .appendingPathComponent("quizzes")
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
    
    // Get all categorized quizzes - Firebase
    func getAllCategories(completion: @escaping (Result<(categories: [Category], quizzes: [Quiz])?, NetworkingError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.noRepresentation)) }
        
        self.quizzes = []
        self.categoryStrings = []
        
        let requestURL = baseURL
            .appendingPathComponent("categories")
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error fetching categorized quizzes: \(error)")
                completion(.failure(.unsuccessfulFetch))
                return
                // TODO: - Alert the user
            }
            
            if (response as? HTTPURLResponse) != nil {
                // TODO: - Handle response | response.statusCode
            }
            
            if let data = data {
                do {
                    let categories = try JSONDecoder().decode([Category].self, from: data)
                    
                    // Save categories and quizzes
                    for category in categories {
                        self.categoryStrings?.append(category.name)
                        
                        for quizRep in category.quizzes {
                            let quiz = Quiz(quizRep: quizRep, context: CoreDataStack.shared.mainContext)
                            self.quizzes?.append(quiz)
                        }
                    }
                    completion(.success((categories, self.quizzes!)))
                } catch {
                    print("\nBad decode\n")
                    completion(.failure(.badDecode))
                }
            }
        }.resume()
    }
    
    // MARK: - CoreData
    
    // Create new Quiz and save in CD WITHOUT any quotes
    func createEmptyQuiz(category: String, context: NSManagedObjectContext) {
        guard let title = title,
              let creator = user else { return }
        
        quiz = Quiz(title: title, creator: creator, category: category, context: context)
        guard let categoryStrings = self.categoryStrings,
              let quiz = quiz else { return }
        
        // Check if we need to create a new category
        if categoryStrings.contains(category) {
            putInCategory(quiz: quiz, category: category) { (result) in
                do {
                    _ = try result.get()
                } catch {
                    NSLog("\nCouldn't put quiz in category: \(error)")
                    // TODO: - Alert User
                }
            }
        } else {
            createNew(category: category) { (result) in
                do {
                    _ = try result.get()
                } catch {
                    NSLog("\nCouldn't save new category in FB: \(error)")
                    // TODO: - Alert user
                }
            }
        }
        
        // Save in user's account
        put(quiz: quiz) { (result) in
            
            do {
                _ = try result.get()
                // Add to quizzes by category
                self.putInCategory(quiz: quiz, category: category) { (result) in
                    do {
                        _ = try result.get()
                        creator.addToQuizzesCreated(quiz)
                        CoreDataStack.shared.save(context: context)
                        
                    } catch {
                        NSLog("Couldn't add new quiz in category on server: \(error)")
                    }
                }
            } catch {
                NSLog("Couldn't save new quiz created by user on server: \(error)")
            }
        }
    }
    
    // Add a new quote to the quiz
    func createQuote(firstPart: String?, secondPart: String?, answer: String, incorrectAnswers: [String], context: NSManagedObjectContext) {
        guard let quiz = quiz,
              let quizID = quiz.id,
              let category = quiz.category else { return }
        
        syncUser()
        
        // If there's less than 16 quotes in the array, create this new quote and add it to the quiz
        if quotes.count < 16 {
            
            let quote = Quote(quizID: quizID.uuidString, firstPart: firstPart ?? "", secondPart: secondPart ?? "", incorrectOptions: incorrectAnswers, answer: answer, context: context)
            
            quoteController.putQuoteForUser(quote: quote, quizID: quizID) { (userResult) in
                
                do {
                    // Saving on user's account
                    _ = try userResult.get()
                    
                    self.quoteController.putForQuizBy(category: category, quote: quote, quizID: quizID) { (quizResult) in
                        do {
                            // Saving in categorized Quizzes
                            _ = try quizResult.get()
                            self.quotes[self.quotes.count + 1] = quote
                            quiz.addToQuotes(quote)
                            CoreDataStack.shared.save(context: context)
                        } catch {
                            NSLog("Failed to save Quote for categorized Quiz in Firebase: \(error)")
                            // TODO: - Alert User
                        }
                    }
                } catch {
                    NSLog("Failed to save Quote for user in Firebase: \(error)")
                    // TODO: - Alert User
                }
            }
        } else {
            // TODO: - Alert the user they can't create a Quiz with more than 15 Quotes
        }
    }
}
