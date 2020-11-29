//
//  NewQuizViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import UIKit

class NewQuizViewController: UIViewController {
    
    // MARK: - Poperties
    
    var quizController: QuizController?
    var user: User?
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        guard let _ = user,
              let quizController = quizController else { return }
        
        // Create empty Quiz then segue
        if let title = titleTextField.text,
           !title.isEmpty {
            quizController.title = titleTextField.text
            
            quizController.createEmptyQuiz(context: CoreDataStack.shared.mainContext)
            
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
