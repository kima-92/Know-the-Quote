//
//  Quiz+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

//import Foundation
import CoreData

extension Quiz {
    
    // Representation
    var quizRepresentation: QuizRepresentation? {
        var quotesReps: [QuoteRepresentation] = []
        
        guard let id = id,
              let title = title,
              let date = dateCreated,
              let creator = creator,
              let creatorRep = creator.userRepresentation,
              let quotes = quotes else { return nil }
        
        // Getting the representation of each quote
        for quote in quotes {
            let q = quote as? Quote
            if let quoteRep = q?.quoteRepresentation {
                quotesReps.append(quoteRep)
            }
        }
        
        return QuizRepresentation(id: id, title: title, dateCreated: date, creator: creatorRep, quotes: quotesReps, hasBeenReported: hasBeenReported)
    }
    
    // Init
    @discardableResult convenience init(title: String, creator: User, context: NSManagedObjectContext) {
        self.init(context: context)
        
        id = UUID()
        dateCreated = Date()
        
        self.title = title
        self.creator = creator
        
        // * NOTE * : Quotes are NOT being added here
    }
}
