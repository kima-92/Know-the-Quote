//
//  QuizzesTableViewController.swift
//  Know the Quote
//
//  Created by macbook on 11/7/20.
//

import UIKit
import CoreData

class QuizzesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var kqController: KQController?
    var user: User?
    var categories: [Int : Category]?
    var quizzes: [Quiz]?
    
    //    var fetchedResultController: NSFetchedResultsController<Quiz> {
    //        let fetchRequest: NSFetchRequest<Quiz> = Quiz.fetchRequest()
    //        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    //
    //        let moc = CoreDataStack.shared.mainContext
    //        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    //        fetchResultsController.delegate = self
    //
    //        do {
    //            try fetchResultsController.performFetch()
    //        } catch {
    //            NSLog("Failed to fetch Quizzes from CoreData: \(error)")
    //        }
    //        return fetchResultsController
    //    }
    
    // MARK: - DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuizzes()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return fetchedResultController.fetchedObjects?.count ?? 0
        return quizzes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTableViewCell", for: indexPath) as? QuizTableViewCell,
              let quizzes = quizzes else { return UITableViewCell() }
        
        //        let quiz = fetchedResultController.object(at: indexPath)
        let quiz = quizzes[indexPath.row]
        cell.titleLabel.text = quiz.title
        cell.quoteCountLabel.text = String(quiz.quotes?.count ?? 0)
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // MARK: - Methods
    
    private func fetchQuizzes() {
        guard let kqController = kqController else { return }
        
        kqController.quizController.getAllCategories { (result) in
            do {
                let touple = try result.get()
                
                if let categories = touple?.categories {
                    var counter = 0
                    
                    for cat in categories {
                        self.categories![counter] = cat
                        counter += 1
                    }
                }
                self.quizzes = touple?.quizzes
            } catch {
                print("\ncouln't fetch categorzed quizzes\n")
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // QuizVC
        if segue.identifier == "ShowQuizSegue" {
            guard let quizVC = segue.destination as? QuizViewController,
                  let quizzes = quizzes else { return }
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //                quizVC.quiz = fetchedResultController.object(at: indexPath)
                quizVC.quiz = quizzes[indexPath.row]
                quizVC.user = user
                quizVC.kqController = kqController
            }
        }
    }
}

// MARK: - Extensions

extension QuizzesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                  let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
