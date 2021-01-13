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
    }
}

extension Category {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CategoryKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
        let quizzes = try container.decode([String : QuizRepresentation].self, forKey: .quizzes)
        self.quizzes = []
        
        for quizPair in quizzes {
            self.quizzes.append(quizPair.value)
        }
    }
}


