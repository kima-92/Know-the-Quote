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
    
    var dataDictionary: [QuotePart : String] = [:]
    var textFields: [QuotePart: UITextField]?
    var incorrectOptsDictionary: [QuotePart : String] = [:]
    
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
        updateButtonsViews(clearTextFields: true)
    }
    
    // MARK: - Actions
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        moveToPrev()
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        moveToNext()
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        saveQuiz()
    }
    
    // MARK: - Methods
    
    private func moveToPrev() {
        guard let quizController = quizController,
              quizController.canMoveToPrev() else { return }
        quizController.moveToPrevQuote()
        displayQuoteData()
    }
    
    // Check if you need to display an existing quote or create a new one
    private func moveToNext() {
        guard let quizController = quizController,
              quizController.canMoveToNext()
        else {
            // TODO: - Alert user you can't move forward
            return
        }
        
        if quizController.currentQuote == quizController.quotes.count + 1 {
            // New quote
            
            saveQuote()
            quizController.moveToNextQuote()
            updateButtonsViews(clearTextFields: true)
        
        } else if quizController.currentQuote == quizController.quotes.count {
            // Clear the screen for the next new Quote
            
            // TODO: - Save changes made to this quote
            quizController.moveToNextQuote()
            updateButtonsViews(clearTextFields: true)
        
        } else {
            // Display next quote
            
            // TODO: - Save changes made to this quote
            quizController.moveToNextQuote()
            displayQuoteData()
        }
    }
    
    // Fill in the textFields with a Quote's data
    private func displayQuoteData() {
        
        guard let quizController = quizController,
              let quote = quizController.quotes[quizController.currentQuote],
              let incorrectOptions = quote.incorrectOptions as? [QuotePart : String]  else { return }
        
        part1TextField.text = quote.firstPart
        part2TextField.text = quote.secondPart
        correctAnswTextField.text = quote.answer
        incorrectOpt1TextField.text = incorrectOptions[.incorrectOpt1]
        incorrectOpt2TextField.text = incorrectOptions[.incorrectOpt2]
        incorrectOpt3TextField.text = incorrectOptions[.incorrectOpt3]
        incorrectOpt4TextField.text = incorrectOptions[.incorrectOpt4]
        
        updateButtonsViews(clearTextFields: false)
    }
    
    // Save the Quiz and popToRoot
    private func saveQuiz() {
        guard let quizController = quizController else { return }
        quizController.createQuiz(context: CoreDataStack.shared.mainContext)
        
        // TODO: - Alert the user if the quiz was not created successfully
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Save this Quote if the Data is complete
    private func saveQuote() {
        guard collectCompleteData(),
              let quizController = quizController else { return }
        
        quizController.createQuote(firstPart: dataDictionary[.part1], secondPart: dataDictionary[.part2], answer: dataDictionary[.answer]!, incorrectAnswers: incorrectOptsDictionary, context: CoreDataStack.shared.mainContext)
    }
    
    // Store data from all textFields or alert user the data is not complete
    private func collectCompleteData() -> Bool {
        
        guard let textFields = textFields else { return false }
        
        // Save the textField's text in the respective distionary or alert the user the textFields is empty
        for (key, textField) in textFields {
            
            if let text = textField.text,
               !text.isEmpty {
                
                switch key {
                case .part1:
                    self.dataDictionary[key] = text
                case .part2:
                    self.dataDictionary[key] = text
                case .answer:
                    self.dataDictionary[key] = text
                case .incorrectOpt1:
                    self.incorrectOptsDictionary[key] = text
                case .incorrectOpt2:
                    self.incorrectOptsDictionary[key] = text
                case .incorrectOpt3:
                    self.incorrectOptsDictionary[key] = text
                case .incorrectOpt4:
                    self.incorrectOptsDictionary[key] = text
                }
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
    
    // Disable/Enable buttons and clear (or not) TextFields
    private func updateButtonsViews(clearTextFields: Bool) {
        guard let quizController = quizController,
              let textFields = textFields else { return }
        
        // Clear the textFields
        if clearTextFields {
            for textField in textFields.values {
                textField.text = ""
            }
        }
        
        // Prev Button
        if quizController.canMoveToPrev() {
            enable(button: prevButton)
        } else {
            disable(button: prevButton)
        }
    
        // Next Button
        if quizController.canMoveToNext() {
            enable(button: nextButton)
        } else {
            disable(button: nextButton)
        }
    
        // Done Button
        if quizController.quizCanBeSaved() {
            enable(button: doneButton)
        } else {
            disable(button: doneButton)
        }
    }

    // Enable/Disable a button
    private func enable(button: UIButton) {
        button.isEnabled = true
        button.alpha = 1
    }
    private func disable(button: UIButton) {
            button.isEnabled = false
            button.alpha = 0.5
    }
}
