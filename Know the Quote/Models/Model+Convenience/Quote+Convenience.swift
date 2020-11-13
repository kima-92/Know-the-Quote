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
              let incorrectOptions = incorrectOptions as? [String] else { return nil }
        
        return QuoteRepresentation(firstPart: first, secondPart: second, answer: answer, quiz: quizRep, incorrectOptions: incorrectOptions, allOptions: allOptions)
    }
    
    // Init
    @discardableResult convenience init(firstPart: String = "", secondPart: String = "", incorrectOptions: [String], answer: String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.incorrectOptions = incorrectOptions as NSArray
        self.firstPart = firstPart
        self.secondPart = secondPart
        self.answer = answer
        
        var allOptions = incorrectOptions
        allOptions.append(answer)
        
        self.allOptions = allOptions as NSArray
    }
}
