//
//  LogInViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    // MARK: - Poperties
    
    var quizController = QuizController()
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
    }
    
    private func getUser() {
//        // Try fetch user from CD
//        if let users = quizController.getAllUsersFromCD(),
//           users.count > 0 {
//            let userOneArr = users.filter({$0.username == "userOne"})
//            if let userOne = userOneArr.first {
//                user = userOne
//            }
//        }
        
        quizController.fetch(username: "userOne", password: "pass") { (result) in
            do {
                self.user = try result.get()
            } catch {
                // Create new user
                self.user = self.quizController.createUser(username: "userOne", password: "pass", context: CoreDataStack.shared.mainContext)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // HomeVC
        if segue.identifier == "showHomeSBsegue" {
            guard let homeVC = segue.destination as? HomeViewController else { return }
            
            homeVC.user = user
            homeVC.quizController = quizController
        }
    }
}
