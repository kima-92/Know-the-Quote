//
//  QuizResultTableViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/13/20.
//

import UIKit

class QuizResultTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var kqController: KQController?
    var user: User?
    var quiz: Quiz?
    var score: Score?
    
    // MARK: - Outlets

    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return score?.answers.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let kqController = kqController,
              let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteResultCell", for: indexPath) as? QuoteResultTableViewCell else { return UITableViewCell() }
        
        cell.score = score
        cell.quote = kqController.quizController.quotes[indexPath.row + 1]
        cell.updateCell()

        return cell
    }
    
    // MARK: - Methods
    
    private func updateViews() {
        guard let quiz = quiz,
              let score = score else { return }
        
        scoreLabel.text = "Score: " + String(score.points)
        quizTitleLabel.text = quiz.title
    }
}
