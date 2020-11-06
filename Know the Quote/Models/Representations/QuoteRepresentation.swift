//
//  Quote.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation

struct QuoteRepresentation {
    
    var firstPart: String
    var secondPart: String
    var answer: String
    var quiz: QuizRepresentation
    var incorrectOptions: [QuotePart : String]
    var allOptions: [String]
}
