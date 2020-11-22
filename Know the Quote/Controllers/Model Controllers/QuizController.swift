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
    
    // Create new Quiz and save in CD WITHOUT any quotes
    func createEmptyQuiz(context: NSManagedObjectContext) {
        guard let title = title,
              let creator = creator else { return }
        
        quiz = Quiz(title: title, creator: creator, context: context)
        guard let quiz = quiz else { return }
        
        creator.addToQuizzesCreated(quiz)
        put(quiz: quiz, id: quiz.id?.uuidString ?? "1") { (result) in
            
            if let err = result as? NetworkingError {
                print("Something went wrong")
            } else {
                CoreDataStack.shared.save(context: context)
            }
        }
    }
    
    // Save Quiz in Firebase
    func put(quiz: Quiz, id: String, completion: @escaping (Result<QuizRepresentation?, NetworkingError>) -> Void) {
        
        guard let quizRep = quiz.quizRepresentation else { return }
        
        let requestURL = baseURL
            .appendingPathComponent("Quizzes")
            .appendingPathComponent(id)
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
    
    // Add a new quote to the quiz
    func createQuote(firstPart: String?, secondPart: String?, answer: String, incorrectAnswers: [String], context: NSManagedObjectContext) {
        
        // If there's less than 16 quotes in the array, create this new quote and add it to the quiz
        if quotes.count < 16 {
            
            let quote = Quote(firstPart: firstPart ?? "", secondPart: secondPart ?? "", incorrectOptions: incorrectAnswers, answer: answer, context: context)
            
            self.quotes[quotes.count + 1] = quote
            guard let quiz = quiz else { return }
            quote.quizID = quiz.id?.uuidString
            quiz.addToQuotes(quote)
            
            CoreDataStack.shared.save(context: context)
        } else {
            // TODO: - Alert the user they can't create a Quiz with more than 15 Quotes
        }
    }
    
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
    
    // Return the next quote that needs to be displayed
    func nextQuoteToDisplay() -> Quote? {
        if currentQuote < quotes.count {
            
            currentQuote += 1
            return quotes[currentQuote]
        }
        return nil
    }
}
