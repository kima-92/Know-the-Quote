//
//  Quiz+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation

extension Quiz {
    
    var quizRepresentation: QuizRepresentation? {
        var theQuotes: [Quote] = []
        
        guard let id = id,
              let title = title,
              let date = dateCreated,
              let creator = creator else { return nil }
        
        if let storedQuotes = quotes {
            
            for quote in storedQuotes {
                theQuotes.append(quote as! Quote)
            }
        }
        
        return QuizRepresentation(id: id, title: title, dateCreated: date, creator: creator, quotes: theQuotes, hasBeenReported: hasBeenReported)
    }
}
