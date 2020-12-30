//
//  User+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import CoreData

extension User {
    
    var userRepresentation: UserRepresentation? {
        var quizesCreatedIDs: [String] = []
        
        guard let id = id,
              let username = username,
              let password = password,
              let quizzes = quizzesCreated,
              let signupDate = signupDate else { return nil }
        
        // Storing the ID of each Quiz
        for quizElement in quizzes {
            if let quiz = quizElement as? Quiz,
               let id = quiz.id {
                quizesCreatedIDs.append(id.uuidString)
            }
        }
        return UserRepresentation(id: id, signupDate: signupDate, username: username, password: password, coins: coins, quizesCreatedIDs: quizesCreatedIDs)
    }
    
    // Init from Representation
    @discardableResult convenience init?(userRep: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(username: userRep.username, password: userRep.password, context: context)
        id = userRep.id
        signupDate = userRep.signupDate
        coins = userRep.coins
        
        // TODO: - Handle quizzesCreated
    }
    
    // Init
    @discardableResult convenience init(username: String, password: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        id = UUID()
        signupDate = Date()
        coins = 250
        quizzesCreated = []
        
        self.username = username
        self.password = password
    }
}
