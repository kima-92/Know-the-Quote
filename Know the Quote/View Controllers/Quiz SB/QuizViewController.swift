//
//  QuizViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/7/20.
//

import UIKit

class QuizViewController: UIViewController {
    
    // MARK: - Properties
    
    var quizController: QuizController?
    var user: User?
    var quiz: Quiz?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
    }
    
    // MARK: - Methods
    
    private func updateViews() {
        guard let quiz = quiz,
              let _ = quizController,
              let _ = user else { return }
        titleLabel.text = quiz.title
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
