//
//  NewQuoteViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/4/20.
//

import UIKit

class NewQuoteViewController: UIViewController {
    
    // MARK: - Poperties
    
    var quizController: QuizController?
    var user: User?
    
    // MARK: - Outlets

    @IBOutlet weak var part1TextField: UITextField!
    @IBOutlet weak var part2TextField: UITextField!
    @IBOutlet weak var correctAnswTextField: UITextField!
    
    @IBOutlet weak var incorrectOpt1TextField: UITextField!
    @IBOutlet weak var incorrectOpt2TextField: UITextField!
    @IBOutlet weak var incorrectOpt3TextField: UITextField!
    @IBOutlet weak var incorrectOpt4TextField: UITextField!
    
    // MARK: - DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
    }
}
