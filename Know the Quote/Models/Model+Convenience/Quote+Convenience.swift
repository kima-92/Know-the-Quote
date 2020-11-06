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
              let allOptions = allOptions as? [String],
              let incorrectOptions = incorrectOptions as? [QuotePart : String] else { return nil }
        
        return QuoteRepresentation(firstPart: first, secondPart: second, answer: answer, quiz: quizRep, incorrectOptions: incorrectOptions, allOptions: allOptions)
    }
    
    // Init
    @discardableResult convenience init(firstPart: String = "", secondPart: String = "", incorrectOptions: [QuotePart : String], answer: String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.firstPart = firstPart
        self.secondPart = secondPart
        self.answer = answer
        self.incorrectOptions = incorrectOptions as NSObject
        
        // Adding the correct answer among the options
        allOptions = {
            var arr = incorrectOptions
            arr[.answer] = answer
            
            return arr as NSObject
        }()
    }
}
