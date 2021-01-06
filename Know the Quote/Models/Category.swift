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
    
    enum CategoryKeys : String, CodingKey {
        case name
        case quizzes
        
        enum QuizIDKeys: String, CodingKey {
            case quiz
        }
    }
}

extension Category {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CategoryKeys.self)
        
        try container.encode(name, forKey: .name)
        
        var quizzesContainer = container.nestedContainer(keyedBy: CategoryKeys.QuizIDKeys.self, forKey: .quizzes)
        var quizzesDict : [String : QuizRepresentation] = [:]
        
        for quiz in quizzes {
            quizzesDict[quiz.id.uuidString] = quiz
            try quizzesContainer.encode(quiz, forKey: .quiz)
        }
    }
}
