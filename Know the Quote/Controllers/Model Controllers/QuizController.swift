//
//  QuizController.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation
import CoreData

class QuizController {
    
    // MARK: - Properties
    
    var quiz: Quiz?
    var currentQuote = 1
    
    var title: String?
    var creator: User?
    var quotes: [Int : Quote] = [:]
    
    let quoteCountMin = 0
    let quoteCountMax = 15
    let currentQuoteMinIndex = 1
    let currentQuoteMaxIndex = 14
    let quizMinQuotes = 3
    let quizMaxQuotes = 15
    
    // MARK: - Methods
    
    // Create new Quiz and save in CD WITHOUT any quotes
    func createEmptyQuiz(context: NSManagedObjectContext) {
        
        guard let title = title,
              let creator = creator else { return }
        
        quiz = Quiz(title: title, creator: creator, context: context)
        guard let quiz = quiz else { return }
        
        creator.addToQuizzesCreated(quiz)
        CoreDataStack.shared.save(context: context)
    }
    
    // Add a new quote to the quiz
    func createQuote(firstPart: String?, secondPart: String?, answer: String, incorrectAnswers: [QuotePart : String], context: NSManagedObjectContext) {
        
        // If there's less than 16 quotes in the array, create this new quote and add it to the quiz
        if quotes.count < 16 {
            let quote = Quote(firstPart: firstPart ?? "", secondPart: secondPart ?? "", incorrectOptions: incorrectAnswers, answer: answer, context: context)
            
            self.quotes[quotes.count + 1] = quote
            guard let quiz = quiz else { return }
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
        if quotes.count <= quoteCountMax && currentQuote <= currentQuoteMaxIndex { currentQuote += 1 }
    }
    func moveToPrevQuote() {
        if quotes.count != quoteCountMin && currentQuote >= currentQuoteMinIndex { currentQuote -= 1 }
    }
}
