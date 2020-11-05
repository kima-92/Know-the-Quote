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
    
    var dataDictionary: [QuotePart : String]?
    var textFields: [QuotePart: UITextField]?
    
    // MARK: - Outlets
    
    // TextFields
    @IBOutlet weak var part1TextField: UITextField!
    @IBOutlet weak var part2TextField: UITextField!
    @IBOutlet weak var correctAnswTextField: UITextField!
    
    @IBOutlet weak var incorrectOpt1TextField: UITextField!
    @IBOutlet weak var incorrectOpt2TextField: UITextField!
    @IBOutlet weak var incorrectOpt3TextField: UITextField!
    @IBOutlet weak var incorrectOpt4TextField: UITextField!
    
    // Buttons
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gatherTextFields()
        updateButtonsViews()
    }
    
    // MARK: - Actions
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        updateButtonsViews()
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        saveQuote()
        updateButtonsViews()
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        updateButtonsViews()
        saveQuiz()
    }
    
    // MARK: - Methods
    
    private func saveQuiz() {
        guard let quizController = quizController else { return }
        quizController.createQuiz(context: CoreDataStack.shared.mainContext)
        
        // TODO: - Alert the user if the quiz was not created successfully
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Save this Quote if the Data is complete
    private func saveQuote() {
        guard collectCompleteData(),
              let quizController = quizController,
              let dataDictionary = dataDictionary else { return }
        
        // Incorrect Options array
        let incorrectOptions = [dataDictionary[.incorrectOpt1]!, dataDictionary[.incorrectOpt2]!, dataDictionary[.incorrectOpt3]!, dataDictionary[.incorrectOpt4]!]
        
        quizController.createQuote(firstPart: dataDictionary[.part1], secondPart: dataDictionary[.part2], incorrectAnswers: incorrectOptions, correctAnswer: dataDictionary[.answer]!, context: CoreDataStack.shared.mainContext)
    }
    
    // Store data from all textFields or alert user the data is not complete
    private func collectCompleteData() -> Bool {
        dataDictionary = [:]
        
        guard let _ = dataDictionary,
              let textFields = textFields else { return false }
        
        // Save the textField's text in the textsDict or alert the user the textFields is empty
        for (key, textField) in textFields {
            if let text = textField.text,
               !text.isEmpty {
                self.dataDictionary![key] = text
            } else {
                // TODO: - Alert the user this textField can't be empty
                return false
            }
        }
        return true
    }
    
    // Add all textFields to the array
    private func gatherTextFields() {
        textFields = [:]

        textFields?[.part1] = part1TextField
        textFields?[.part2] = part2TextField
        textFields?[.answer] = correctAnswTextField
        textFields?[.incorrectOpt1] = incorrectOpt1TextField
        textFields?[.incorrectOpt2] = incorrectOpt2TextField
        textFields?[.incorrectOpt3] = incorrectOpt3TextField
        textFields?[.incorrectOpt4] = incorrectOpt4TextField
    }
    
    private func updateButtonsViews() {
        guard let quizController = quizController,
              let textFields = textFields else { return }
        
        // Clear the textFields
        for textField in textFields.values {
            textField.text = ""
        }
        
        let count = quizController.quotes.count
        
        // Prev Button
        if count == 0 {
            prevButton.isEnabled = false
            prevButton.alpha = 0.5
        } else {
            prevButton.isEnabled = true
            prevButton.alpha = 1
        }
        
        // Done Button
        if count >= 3 && count < 16 {
            doneButton.isEnabled = true
            doneButton.alpha = 1
        } else {
            doneButton.isEnabled = false
            doneButton.alpha = 0.5
        }
        
        // Next Button
        if count < 15 {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
}
