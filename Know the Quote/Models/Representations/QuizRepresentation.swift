//
//  Quiz.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import UIKit

struct QuizRepresentation: Codable {
    
    var id: UUID
    var title: String
    var dateCreated: Date
    var creatorID: String
    var quotes: [QuoteRepresentation]
    var hasBeenReported: Bool
    var category: String
}
