//
//  Quote.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation

struct QuoteRepresentation: Codable {
    
    var quoteID: UUID
    var firstPart: String
    var secondPart: String
    var answer: String
    var quizID: UUID
    var incorrectOptions: [String]
    var allOptions: [String]
    
    // MARK: Unlike the Quote CD model, this one doesn't have a quiz object
}
