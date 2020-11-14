//
//  QuoteResultTableViewCell.swift
//  Know the Quote
//
//  Created by macbook on 11/13/20.
//

import UIKit

class QuoteResultTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var answerChosenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
