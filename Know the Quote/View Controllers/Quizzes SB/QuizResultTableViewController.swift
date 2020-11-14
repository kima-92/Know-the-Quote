//
//  QuizResultTableViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/13/20.
//

import UIKit

class QuizResultTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var quizController: QuizController?
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
        
        guard let quizController = quizController,
              let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteResultCell", for: indexPath) as? QuoteResultTableViewCell else { return UITableViewCell() }
        
        cell.score = score
        cell.quote = quizController.quotes[indexPath.row + 1]
        cell.updateCell()

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Methods
    
    private func updateViews() {
        guard let quiz = quiz,
              let score = score else { return }
        
        scoreLabel.text = "Score: " + String(score.points)
        quizTitleLabel.text = quiz.title
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
