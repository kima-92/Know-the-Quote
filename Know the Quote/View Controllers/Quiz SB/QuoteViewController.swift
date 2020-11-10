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
        updateViews()
    }
    
    // MARK: - Methods
    
    private func gatherButtons() {
        buttons.append(opt1Button)
        buttons.append(opt2Button)
        buttons.append(opt3Button)
        buttons.append(opt4Button)
        buttons.append(opt5Button)
    }
    
    private func displayQuote() {
//        guard let quizController = quizController,
//              let quiz = quiz else { return }
//
//        quizController.getAllQuotes(quiz: quiz)
//        quoteLabel.text = quizController.getCurrentQuoteText()
    }
    
    private func setAllOptions() {
//        guard let quizController = quizController,
//              let quote = quizController.currentQuote1 else { return }
//
//        if let options = quote.allOptions as? [String] {
//
//            for option in options {
//                for button in buttons {
//                    button?.setTitle(option, for: .normal)
//                }
//            }
//        }
    }
    
    private func updateViews() {
        guard let quizController = quizController,
              let quiz = quiz else { return }
        
        displayQuote()
        setAllOptions()
    }
}
