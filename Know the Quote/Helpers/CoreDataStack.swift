//
//  CoreDataStack.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation
import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    // Setup a persistent container
    lazy var container: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "KnowTheQuote")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }

        // MARK: Automatically merging changes from parent
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    func save(context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
}
