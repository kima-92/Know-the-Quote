//
//  KQController.swift
//  Know the Quote
//
//  Created by macbook on 11/28/20.
//

import Foundation
import Firebase
import CoreData

class KQController {
    
    // MARK: - Properties
    
    private let baseURL = URL(string: "https://know-the-quote.firebaseio.com/")!
    let db = Firestore.firestore()
    var user: User?
    
    var userController: UserController
    var quizController: QuizController
    
    // MARK: - Init
    
    init() {
        self.userController = UserController(baseURL: baseURL, db: db)
        self.quizController = QuizController(baseURL: baseURL, db: db)
    }
    
    // MARK: - Methods
    
    func syncUser() {
        if self.user != userController.user || quizController.user != userController.user {
            self.user = userController.user
            quizController.user = userController.user
        }
    }
    
    func createUserAndSync(username: String, password: String, context: NSManagedObjectContext) -> User? {
        let user = userController.createUser(username: username, password: password, context: context)
        syncUser()
        return user
    }
}
