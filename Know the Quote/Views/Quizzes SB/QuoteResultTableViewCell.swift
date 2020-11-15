//
//  QuoteResultTableViewCell.swift
//  Know the Quote
//
//  Created by macbook on 11/13/20.
//

import UIKit

class QuoteResultTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var quote: Quote?
    var score: Score?
    
    // MARK: - Outlets

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var answerChosenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    
    func updateCell() {
        guard let quote = quote,
              let score = score,
              let first = quote.firstPart,
              let second = quote.secondPart,
              let chosenAnswer = score.answers[quote] else { return }
        
        quoteLabel.text = first + " _____ " + second
        answerChosenLabel.text = chosenAnswer.selection
        
        // Change color based if user was correct
        if chosenAnswer.isCorrect {
            answerChosenLabel.backgroundColor = UIColor(red: 80/255, green: 200/255, blue: 120/255, alpha: 0.5)
            
        } else {
            answerChosenLabel.backgroundColor = UIColor(red: 214/255, green: 44/255, blue: 67/255, alpha: 0.5)
        }
        answerChosenLabel.layer.masksToBounds = true
        answerChosenLabel.layer.cornerRadius = 5
    }
}
