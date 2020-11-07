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
              let allOptions = allOptions as? [QuotePartModel : String],
              let incorrectOptions = incorrectOptions as? [QuotePartModel : String] else { return nil }
        
        // Transforming QuotePartModels to QuoteParts
        var incOpts: [QuotePart : String] = [:]
        var allOpts: [String] = []
        
        for (key, value) in incorrectOptions { incOpts[key.quotePart] = value }
        for i in allOptions.values { allOpts.append(i) }
        
        return QuoteRepresentation(firstPart: first, secondPart: second, answer: answer, quiz: quizRep, incorrectOptions: incOpts, allOptions: allOpts)
    }
    
    // Init
    @discardableResult convenience init(firstPart: String = "", secondPart: String = "", incorrectOptions: [QuotePart : String], answer: String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        var tempAllAnswers: [String] = []
        var tempIncorrectOpts: [QuotePartModel : String] = [:]
        
        // Transform each key from a QuotePart to QuotePartModel so it can be saved in CoreData
        for (key, value) in incorrectOptions {
            let quotePartModel = QuotePartModel(context: CoreDataStack.shared.mainContext)
            quotePartModel.quotePart = key
            
            tempAllAnswers.append(value)
            tempIncorrectOpts[quotePartModel] = value
        }
        
        // Finish creating allAnsweres
        tempAllAnswers.append(answer)
        
        self.allOptions = tempAllAnswers as NSArray
        self.incorrectOptions = tempIncorrectOpts as NSDictionary
        self.firstPart = firstPart
        self.secondPart = secondPart
        self.answer = answer
    }
}
