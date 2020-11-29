//
//  User+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import CoreData

extension User {
    
    var userRepresentation: UserRepresentation? {
        var quizesIDs: [String] = []
        
        guard let id = id,
              let username = username,
              let password = password,
              let quizesCreatedIDs = quizzesCreated,
              let signupDate = signupDate else { return nil }
        
        // Storing the ID of each Quiz
        for quizElement in quizesCreatedIDs {
            if let quiz = quizElement as? Quiz,
               let id = quiz.id {
                quizesIDs.append(id.uuidString)
            }
        }
        return UserRepresentation(id: id, signupDate: signupDate, username: username, password: password, coins: coins, quizesCreatedIDs: quizesIDs)
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
