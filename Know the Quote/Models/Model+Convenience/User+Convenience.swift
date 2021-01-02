//
//  User+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import CoreData

extension User {
    
    var userRepresentation: UserRepresentation? {
//        var quizesCreatedIDs: [String] = []
        
        guard let id = id,
              let username = username,
              let password = password,
              let quizzesCreatedIDs = quizzesCreatedIDs as? [String],
              let signupDate = signupDate else { return nil }
        
//        // Storing the ID of each Quiz
//        for quizElement in quizzes {
//            if let quiz = quizElement as? Quiz,
//               let id = quiz.id {
//                quizesCreatedIDs.append(id.uuidString)
//            }
//        }
        return UserRepresentation(id: id, signupDate: signupDate, username: username, password: password, coins: coins, quizzesCreatedIDs: quizzesCreatedIDs)
    }
    
    // Init
    @discardableResult convenience init(username: String, password: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        id = UUID()
        signupDate = Date()
        coins = 250
        quizzesCreatedIDs = [] as NSObject // TODO: - Are they being added after creating this empty array?
        
        self.username = username
        self.password = password
    }
    
    // Init from Representation
    @discardableResult convenience init?(userRep: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(username: userRep.username, password: userRep.password, context: context)
        id = userRep.id
        signupDate = userRep.signupDate
        coins = userRep.coins
        
        if userRep.quizzesCreatedIDs as NSArray? == nil {
            quizzesCreatedIDs = [] as NSObject // TODO: - Are they being added after creating this empty array?
            return
        }
        quizzesCreatedIDs = userRep.quizzesCreatedIDs as NSArray?
    }
}
