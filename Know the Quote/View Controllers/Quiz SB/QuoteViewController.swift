//
//  QuoteViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/7/20.
//

import UIKit

class QuoteViewController: UIViewController {
    
    // MARK: - Properties
    
    var quizController: QuizController?
    var user: User?
    var quiz: Quiz?
    var quote: Quote?
    var buttons: [UIButton?] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var opt1Button: UIButton!
    @IBOutlet weak var opt2Button: UIButton!
    @IBOutlet weak var opt3Button: UIButton!
    @IBOutlet weak var opt4Button: UIButton!
    @IBOutlet weak var opt5Button: UIButton!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gatherButtons()
        setupQuiz()
        displayQuote()
    }
    
    // MARK: - Methods
    
    private func gatherButtons() {
        buttons.append(opt1Button)
        buttons.append(opt2Button)
        buttons.append(opt3Button)
        buttons.append(opt4Button)
        buttons.append(opt5Button)
    }
    
    // Display the current quote
    private func displayQuote() {
        guard let quote = quote,
              let first = quote.firstPart,
              let second = quote.secondPart,
              let allOptions = quote.allOptions as? [String] else { return }
        
        quoteLabel.text = first + " _____ " + second
        
        // Buttons
        for option in allOptions {
            for button in buttons {
                button?.setTitle(option, for: .normal)
            }
        }
    }
    
    // Start the Quiz
    private func setupQuiz() {
        guard let quizController = quizController,
              let quiz = quiz else { return }
        
        // Setup the quiz if it hasn't started yet
        if quote == nil {
            self.quote = quizController.setupStart(quiz: quiz)
        }
        // Display the next quote if the quiz already started
        else if let quote = quizController.nextQuoteToDisplay() {
            self.quote = quote
        }
        
        // TODO: - Alert the user something went wrong
    }
    
    private func updateViews() {
        guard let _ = quizController,
              let _ = quiz else { return }
    }
}
