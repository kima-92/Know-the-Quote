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
    
    var kqController = KQController()
    var user: User?
    let username = "userOne" // TODO: - UNHARDCODE THIS LINE!!!!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        fetchCategoryNames()
    }
    
    private func getUser() {
        
        kqController.userController.fetch(username: username, password: "pass") { (result) in
            do {
                self.user = try result.get()
                self.kqController.syncUser()
            } catch {
                // Create new user if fetch was unsuccessfull
                self.user = self.kqController.createUserAndSync(username: self.username, password: "pass", context: CoreDataStack.shared.mainContext)
                // TODO: - Alert user if User object == nil
            }
        }
        
        // MARK: - TESTING PORPUSES
        kqController.userController.fetchAll { (result) in
            do {
                let users = try result.get()
            } catch {
                print("/n/nCouldn't/n/n")
            }
        }
    }
    
    private func fetchCategoryNames() {
        kqController.quizController.getAllCategories(withQuizzes: false) { (result) in
            
            do {
                let _ = try result.get()
            } catch {
                print("\nNo categories where fetched\n")
                // TODO: - Handle catch
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // HomeVC
        if segue.identifier == "showHomeSBsegue" {
            guard let homeVC = segue.destination as? HomeViewController else { return }
            
            homeVC.user = user
            homeVC.kqController = kqController
        }
    }
}
