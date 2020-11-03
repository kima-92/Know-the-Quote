//
//  Quote+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation

extension Quote {
    
    var quoteRepresentation: QuoteRepresentation? {
        var options: [String] = []
        
        guard let first = firstPart,
              let second = secondPart,
              let answer = answer,
              let quiz = quiz,
              let answerOptions = answerOptions as? [String] else { return nil }
        
            
            for option in answerOptions {
                options.append(option)
            }
        
        
        return QuoteRepresentation(firstPart: first, secondPart: second, answerOptions: options, answer: answer, quiz: quiz)
    }
}
