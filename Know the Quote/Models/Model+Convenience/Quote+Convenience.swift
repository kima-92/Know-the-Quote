//
//  Quote+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import CoreData

extension Quote {
    
    var quoteRepresentation: QuoteRepresentation? {
        
        guard let first = firstPart,
              let second = secondPart,
              let answer = answer,
              let quiz = quiz,
              let quizRep = quiz.quizRepresentation,
              let answerOptions = answerOptions as? [String] else { return nil }
        
        // Get the possible answers
        var options: [String] = []
        
        for option in answerOptions {
            options.append(option)
        }
        
        return QuoteRepresentation(firstPart: first, secondPart: second, answerOptions: options, answer: answer, quiz: quizRep)
    }
    
    // Init
    @discardableResult convenience init(firstPart: String = "", secondPart: String = "", incorrectAnswers: [String], correctAnswer: String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.firstPart = firstPart
        self.secondPart = secondPart
        self.answer = correctAnswer
        
        // Adding the correct answer among the options
        answerOptions = {
            var arr = incorrectAnswers
            arr.append(correctAnswer)
            
            return arr as NSObject
        }()
    }
}
