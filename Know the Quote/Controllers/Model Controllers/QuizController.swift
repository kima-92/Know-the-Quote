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
    var quotes: [Quote] = []
    var title: String?
    var creator: User?
    
    // MARK: - Methods
    
    // Create new Quiz and save in CD
    func createQuiz(context: NSManagedObjectContext) {
        
        guard let title = title,
              let creator = creator else { return }
        
        // If there's more than 3 quotes, create the quiz and add it to it's creator's quizzesCreated.
        if quotes.count >= 3 {
            
            let quiz = Quiz(title: title, creator: creator, context: context)
            
            for quote in quotes {
                quiz.addToQuotes(quote)
            }
            creator.addToQuizzesCreated(quiz)
            CoreDataStack.shared.save(context: context)
            
        } else {
            // TODO: - Alert the user they need to add at least 3 Quotes to save the new Quiz
        }
    }
    
    // Add a new quote to the array
    func createQuote(firstPart: String?, secondPart: String?, incorrectAnswers: [String], correctAnswer: String, context: NSManagedObjectContext) {
        
        // If there's less than 16 quotes in the array, create this new quote and add it to the array (NOT saved in CD yet)
        if quotes.count < 16 {
            let quote = Quote(firstPart: firstPart ?? "", secondPart: secondPart ?? "", incorrectAnswers: incorrectAnswers, correctAnswer: correctAnswer, context: context)
            
            self.quotes.append(quote)
        } else {
            // TODO: - Alert the user they can't create a Quiz with more than 15 Quotes
        }
    }
}
