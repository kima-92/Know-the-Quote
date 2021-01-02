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
        var quoteReps: [QuoteRepresentation] = []
        
        guard let id = id,
              let title = title,
              let dateCreated = dateCreated,
              let creatorID = creatorID,
              let categoryName = categoryName else { return nil }
//              let quotes = quotes else { return nil }
        
        // Getting the representation of each quote
        if let quotes = quotes {
            for quoteData in quotes {
                let quote = quoteData as? Quote
                if let quoteRep = quote?.quoteRepresentation {
                    quoteReps.append(quoteRep)
                }
            }
        }
//        for quote in quotes {
//            let q = quote as? Quote
//            if let quoteRep = q?.quoteRepresentation {
//                quotesReps.append(quoteRep)
//            }
//        }
        
        return QuizRepresentation(id: id, title: title, dateCreated: dateCreated, creatorID: creatorID, quoteReps: quoteReps, hasBeenReported: hasBeenReported, categoryName: categoryName)
    }
    
    // Init
    @discardableResult convenience init(title: String, creatorID: UUID, categoryName: String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        id = UUID()
        dateCreated = Date()
        hasBeenReported = false
        self.creatorID = creatorID
        self.title = title
        self.categoryName = categoryName
        
        // * NOTE * : Quotes are NOT being added here
        self.quotes = [] //<-- TODO: - Does this make it crash?
    }
    
    // Init from Representation
    @discardableResult convenience init(quizRep: QuizRepresentation, context: NSManagedObjectContext) {
        self.init(title: quizRep.title, creatorID: quizRep.creatorID, categoryName: quizRep.categoryName, context: context)
        
        id = quizRep.id
        dateCreated = quizRep.dateCreated
        hasBeenReported = quizRep.hasBeenReported
        
        for quoteRep in quizRep.quoteReps {
            self.addToQuotes(Quote(quoteRep: quoteRep, context: context))
        }
        print()
        print(self.quotes)
    }
}
