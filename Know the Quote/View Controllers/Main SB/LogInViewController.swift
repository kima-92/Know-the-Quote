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
        
        quizController.fetch(username: "userOne", password: "pass") { (result) in
            do {
                self.user = try result.get()
            } catch {
                // Create new user
                self.user = self.quizController.createUser(username: "userOne", password: "pass", context: CoreDataStack.shared.mainContext)
                // TODO: - Alert user if User object == nil
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
