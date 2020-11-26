//
//  Quote+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import CoreData

extension Quote {
    
    var quoteRepresentation: QuoteRepresentation? {
        
        guard let quoteID = quoteID,
              let first = firstPart,
              let second = secondPart,
              let answer = answer,
              let quizID = quizID,
              let allOptions = allOptions as? [String],
              let incorrectOptions = incorrectOptions as? [String] else { return nil }
        
        return QuoteRepresentation(quoteID: quoteID, firstPart: first, secondPart: second, answer: answer, quizID: quizID, incorrectOptions: incorrectOptions, allOptions: allOptions)
    }
    
    // Init
    @discardableResult convenience init(quizID: String, firstPart: String = "", secondPart: String = "", incorrectOptions: [String], answer: String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.incorrectOptions = incorrectOptions as NSArray
        self.quoteID = UUID().uuidString
        self.quizID = quizID
        self.firstPart = firstPart
        self.secondPart = secondPart
        self.answer = answer
        
        var allOptions = incorrectOptions
        allOptions.append(answer)
        
        self.allOptions = allOptions as NSArray
    }
}
