//
//  NewQuizViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import UIKit

class NewQuizViewController: UIViewController {
    
    // MARK: - Poperties
    
    var kqController: KQController?
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
              let kqController = kqController else { return }
        
        // Create empty Quiz then segue
        if let title = titleTextField.text,
           !title.isEmpty {
            kqController.quizController.title = titleTextField.text
            
            kqController.quizController.createEmptyQuiz(category: "category1", context: CoreDataStack.shared.mainContext)
            // TODO: - UNhardcode the category!
            
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
                newQuoteVC.kqController = kqController
            }
        }
    }
}
