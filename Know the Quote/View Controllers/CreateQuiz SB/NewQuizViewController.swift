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
    @IBOutlet weak var categoryTextField: UITextField!
    
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
           let categoryName = categoryTextField.text,              // Pick category from menu (should NOT create a new one here)
           !title.isEmpty,
           !categoryName.isEmpty {
            kqController.quizController.title = titleTextField.text
            
            kqController.quizController.createEmptyQuizFor(categoryName: categoryName, context: CoreDataStack.shared.mainContext)
            // TODO: - Find a way to offer the available categories to the user, and if they wish to create a new one, go about it a different way. It should NOT be here! Here only have them add to an existing category. In fact, make sure this category exists before calling this method
            
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
