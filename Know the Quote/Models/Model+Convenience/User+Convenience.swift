//
//  User+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation

extension User {
    
    var userRepresentation: UserRepresentation? {
        var quizes: [QuizRepresentation] = []
        
        guard let id = id,
              let username = username,
              let password = password,
              let quizesCreated = quizesCreated else { return nil }
        
            // Creating a Representation for each Quiz
            for quiz in quizesCreated {
                let q = quiz as? Quiz
                if let quizRep = q?.quizRepresentation {
                    quizes.append(quizRep)
                }
            }
        
        return UserRepresentation(id: id, username: username, password: password, coins: coins, quizesCreated: quizes)
    }
}
