//
//  Quote+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation

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
}
