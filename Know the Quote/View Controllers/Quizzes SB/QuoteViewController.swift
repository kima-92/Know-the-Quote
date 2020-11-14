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
    var score = Score()
    
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
        updateProgressBar()
    }
    
    // MARK: - Action
    
    @IBAction func optButtonTapped(_ sender: UIButton) {
        processSelection(sender)
    }
    
    // MARK: - Methods
    
    // Processing the user's selection and updating UI
    private func processSelection(_ sender: UIButton) {
        guard let quizController = quizController else { return }
        
        updateScore(sender)
        quote = quizController.nextQuoteToDisplay()
        displayQuote()
        
        // Segue to the next VC if this was the last quote
        if quote == nil {
            updateProgressBar(true)
            performSegue(withIdentifier: "ShowQuizResultVCSegue", sender: self)
        } else {
            updateProgressBar()
        }
    }
    
    private func updateProgressBar(_ isLast: Bool = false) {
        guard let quizController = quizController else { return }
        
        if isLast {
            progressView.setProgress(1.0, animated: true)
        } else {
            let currentProgress = Float(quizController.currentQuote - 1) / Float(quizController.quotes.count)
            progressView.setProgress(currentProgress, animated: true)
        }
    }
    
    private func updateScore(_ sender: UIButton) {
        guard let quote = quote,
              let optSelected = sender.title(for: .normal) else { return }
        
        if optSelected == quote.answer {
            score.points += 1
            score.selectedResponses[optSelected] = true
        } else {
            score.selectedResponses[optSelected] = false
        }
    }
    
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
        var options = allOptions.shuffled()
        
        for button in buttons {
            let last = options.popLast()
            button?.setTitle(last, for: .normal)
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowQuizResultVCSegue" {
            guard let quizResultTVC = segue.destination as? QuizResultTableViewController else { return }
            
            quizResultTVC.user = user
            quizResultTVC.quizController = quizController
            quizResultTVC.quiz = quiz
            quizResultTVC.score = score
        }
    }
}