//
//  NewQuoteViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/4/20.
//

import UIKit

class NewQuoteViewController: UIViewController {
    
    // MARK: - Poperties
    
    var kqController: KQController?
    var user: User?
    var incompleteQuote: [QuotePart : String]?
    
    var dataDictionary: [QuotePart : String] = [:]
    var textFields: [QuotePart: UITextField]?
    var incorrectOptsArray: [String] = []
    
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
        updateButtonsViews(clearTextFields: true, shouldEnableNext: false)
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Actions
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        moveToPrev()
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        moveToNext()
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        finishCreatingQuiz()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        guard let kqController = kqController else { return }
        
        if doneButton.isEnabled == false,
           kqController.quizController.quotes.count == 2,
           isDataComplete() {
            
            enable(button: doneButton)
        }
        
        if nextButton.isEnabled == false,
           kqController.quizController.canMoveToNext(),
           isDataComplete() {
            enable(button: nextButton)
        }
    }
    
    // MARK: - Methods
    
    private func moveToPrev() {
        guard let kqController = kqController,
              kqController.quizController.canMoveToPrev() else { return }
        
        saveIncompleteData()
        kqController.quizController.moveToPrevQuote()
        displayQuoteData()
    }
    
    // Saving Incomplete Quote inside an array
    private func saveIncompleteData() {
        incompleteQuote = [:]
        
        guard let textFields = textFields,
              let _ = incompleteQuote else { return }
        
        for (quotePart, textField) in textFields {
            self.incompleteQuote![quotePart] = textField.text
        }
    }
    
    // Check if need to display an existing quote, or set the screen for a new one
    private func moveToNext() {
        guard let kqController = kqController,
              kqController.quizController.canMoveToNext()
        
        else {
            // TODO: - Alert user you can't move forward
            return
        }
        
        let current = kqController.quizController.currentQuote
        let count = kqController.quizController.quotes.count
        
        if current == count + 1 {
            // Saving the latest (unsaved) quote
            
            if saveQuote() { // if it's successfull
                kqController.quizController.moveToNextQuote()
                updateButtonsViews(clearTextFields: true, shouldEnableNext: false)
            }
            
        } else if current == count {
            // Clear out the screen for the next quote,
            // or filling in with the previously (still incomplete) quote
            
            // TODO: - Save changes made to this quote before moving to the next
            
            updateButtonsViews(clearTextFields: true, shouldEnableNext: false) // clear the screen
            kqController.quizController.moveToNextQuote()
            tryLoadIncompleteData()
            
            if isDataComplete() {
                enable(button: nextButton)
            }
        } else {
            // Display next previously saved quote
            
            // TODO: - Save changes made to this quote
            kqController.quizController.moveToNextQuote()
            displayQuoteData()
        }
        resetSets()
    }
    
    // Try to get the incomplete Quote from the incompleteQuoteArray
    private func tryLoadIncompleteData() {
        guard let textFields = textFields,
              let incompleteQuote = incompleteQuote else { return }
        
        for (quotePart, textField) in textFields {
            textField.text = incompleteQuote[quotePart]
        }
        self.incompleteQuote = nil
    }
    
    // Fill in the textFields with a Quote's data
    private func displayQuoteData() {
        guard let kqController = kqController,
              let quote = kqController.quizController.quotes[kqController.quizController.currentQuote],
              let incorrectOptions = quote.incorrectOptions as? [String]  else { return }
        
        part1TextField.text = quote.firstPart
        part2TextField.text = quote.secondPart
        correctAnswTextField.text = quote.answer
        filloutOptsTextFields(incorrectOptions: incorrectOptions)
        
        updateButtonsViews(clearTextFields: false, shouldEnableNext: true)
    }
    
    // Fill out the incorrect options TextFields
    private func filloutOptsTextFields(incorrectOptions: [String]) {
        guard let textFields = textFields else { return }
        
        // Filter out the quotePartModel for this QuotePart, then fill out the textField
        //        for (quotePart, textField) in textFields {
        //            let quotePartModelArray = incorrectOptions.filter({ $0.key.quotePart == quotePart})
        //
        //            if let quotePartModel = quotePartModelArray.first {
        //                textField.text = quotePartModel.value
        //            }
        //        }
        // TODO: - Alert user of something fails
    }
    
    // Finish saving the Quiz and popToRoot
    private func finishCreatingQuiz() {
        guard let kqController = kqController else { return }
        
        if kqController.quizController.quotes.count >= 2,
           isDataComplete(),
           saveQuote() {
            navigationController?.popToRootViewController(animated: true)
        }
        // TODO: - Alert the user if something went wrong
    }
    
    // Save this Quote if the Data is complete
    private func saveQuote() -> Bool {
        guard isDataComplete(),
              let kqController = kqController else { return false }
        
        collectCompleteData()
        
        kqController.quizController.createQuote(firstPart: dataDictionary[.part1], secondPart: dataDictionary[.part2], answer: dataDictionary[.answer]!, incorrectAnswers: incorrectOptsArray, context: CoreDataStack.shared.mainContext)
        return true
    }
    
    // Store data from all textFields or alert user the data is not complete
    private func collectCompleteData() {
        guard let textFields = textFields,
              isDataComplete() else { return }
        
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
                    self.incorrectOptsArray.append(text)
                case .incorrectOpt2:
                    self.incorrectOptsArray.append(text)
                case .incorrectOpt3:
                    self.incorrectOptsArray.append(text)
                case .incorrectOpt4:
                    self.incorrectOptsArray.append(text)
                }
            } else {
                // TODO: - Alert the user this textField can't be empty
            }
        }
    }
    
    private func isDataComplete() -> Bool {
        guard let textFields = textFields else { return false }
        
        // Return false if any of the textFields are empty
        for textField in textFields.values {
            if let text = textField.text,
               text.isEmpty {
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
    private func updateButtonsViews(clearTextFields: Bool, shouldEnableNext: Bool) {
        guard let kqController = kqController,
              let textFields = textFields else { return }
        
        // Clear the textFields
        if clearTextFields {
            for textField in textFields.values {
                textField.text = ""
            }
        }
        
        // Prev Button
        if kqController.quizController.canMoveToPrev() {
            enable(button: prevButton)
        } else {
            disable(button: prevButton)
        }
        
        // Next Button
        if shouldEnableNext,
           kqController.quizController.canMoveToNext() {
            enable(button: nextButton)
        } else {
            disable(button: nextButton)
        }
        
        // Done Button
        if kqController.quizController.quizCanBeSaved() {
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
    
    // Empty stored data
    private func resetSets() {
        incorrectOptsArray = []
        dataDictionary = [:]
    }
}
