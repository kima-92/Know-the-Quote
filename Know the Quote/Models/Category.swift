//
//  Category.swift
//  Know the Quote
//
//  Created by macbook on 12/6/20.
//

import Foundation

struct Category: Codable {
    var name: String
    var quizzes: [QuizRepresentation]
}
