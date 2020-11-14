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
    }
    // TODO: - Change the color of the label based on whether they chose right or wrong
}
