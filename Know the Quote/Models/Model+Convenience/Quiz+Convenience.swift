//
//  Quiz+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import CoreData

extension Quiz {
    
    // Representation
    var quizRepresentation: QuizRepresentation? {
        var quotesReps: [QuoteRepresentation] = []
        
        guard let id = id,
              let title = title,
              let date = dateCreated,
              let creatorID = creatorID,
              let category = category,
              let quotes = quotes else { return nil }
        
        // Getting the representation of each quote
        for quote in quotes {
            let q = quote as? Quote
            if let quoteRep = q?.quoteRepresentation {
                quotesReps.append(quoteRep)
            }
        }
        
        return QuizRepresentation(id: id, title: title, dateCreated: date, creatorID: creatorID, quotes: quotesReps, hasBeenReported: hasBeenReported, category: category)
    }
    
    // Init
    @discardableResult convenience init(title: String, creator: User, category: String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        guard let creatorID = creator.id else { return }
        
        id = UUID()
        dateCreated = Date()
        hasBeenReported = false
        self.creatorID = creatorID.uuidString
        self.title = title
        self.creator = creator
        self.category = category
        
        // * NOTE * : Quotes are NOT being added here
    }
}
