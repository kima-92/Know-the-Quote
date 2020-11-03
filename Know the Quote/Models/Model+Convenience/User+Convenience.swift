//
//  User+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation

extension User {
    
    var userRepresentation: UserRepresentation? {
        var quizes: [Quiz] = []
        
        guard let id = id,
              let username = username,
              let password = password else { return nil }
        
        if let quizesCreated = quizesCreated {
            
            for quiz in quizesCreated {
                quizes.append(quiz as! Quiz)
            }
        }
        
        return UserRepresentation(id: id, username: username, password: password, coins: coins, quizesCreated: quizes)
    }
}
