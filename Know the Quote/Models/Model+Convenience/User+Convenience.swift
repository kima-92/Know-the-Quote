//
//  User+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import CoreData

extension User {
    
    var userRepresentation: UserRepresentation? {
        var quizes: [QuizRepresentation] = []
        
        guard let id = id,
              let username = username,
              let password = password,
              let quizesCreated = quizzesCreated,
              let signupDate = signupDate else { return nil }
        
        // Creating a Representation for each Quiz
        for quiz in quizesCreated {
            let q = quiz as? Quiz
            if let quizRep = q?.quizRepresentation {
                quizes.append(quizRep)
            }
        }
        return UserRepresentation(id: id, signupDate: signupDate, username: username, password: password, coins: coins, quizesCreated: quizes)
    }
    
    // Init
    @discardableResult convenience init(username: String, password: String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        id = UUID()
        signupDate = Date()
        coins = 250
        quizzesCreated = []
        
        self.username = username
        self.password = password
    }
}
