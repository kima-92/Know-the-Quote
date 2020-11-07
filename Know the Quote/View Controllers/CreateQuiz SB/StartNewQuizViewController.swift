//
//  StartNewQuizViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import UIKit

class NewQuizViewController: UIViewController {
    
    // MARK: - Poperties
    
    var quizController = QuizController()
    let user = User(username: "user", password: "pass", context: CoreDataStack.shared.mainContext)
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        // Try to save title and creator then segue to next VC
        if let title = titleTextField.text,
           !title.isEmpty {
            quizController.creator = user
            quizController.title = titleTextField.text
            
            performSegue(withIdentifier: "newQuoteDetailsSegue", sender: self)
        } else {
            // TODO: - Alert the user the title can't be empty
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // NewQuoteVC
        if segue.identifier == "newQuoteDetailsSegue" {
            if let newQuoteVC = segue.destination as? NewQuoteViewController {
                newQuoteVC.user = user
                newQuoteVC.quizController = quizController
            }
        }
    }
}
