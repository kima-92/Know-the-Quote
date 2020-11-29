//
//  HomeViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Poperties
    
    var kqController: KQController?
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // NewQuizVC
        if segue.identifier == "showCreateQuizSBSegue" {
            guard let newQuizVC = segue.destination as? NewQuizViewController else { return }
            
            newQuizVC.user = user
            newQuizVC.kqController = kqController
        }
        
        // QuizzesTVC
        if segue.identifier == "showQuizzesSBSegue" {
            guard let quizzesTVC = segue.destination as? QuizzesTableViewController else { return }
            
            quizzesTVC.user = user
            quizzesTVC.kqController = kqController
        }
    }
}
