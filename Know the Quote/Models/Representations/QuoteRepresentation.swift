//
//  Quote.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation

struct QuoteRepresentation: Codable {
    
    var quoteID: String
    var firstPart: String
    var secondPart: String
    var answer: String
    var quizID: String
    var incorrectOptions: [String]
    var allOptions: [String]
}
