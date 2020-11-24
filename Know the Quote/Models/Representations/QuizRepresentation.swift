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
    var creator: UserRepresentation
    var quotes: [QuoteRepresentation]
    var hasBeenReported: Bool
    
//    func getKeyValueArray() -> {
//        return [
//            "id" : 
//        ]
//    }
}
