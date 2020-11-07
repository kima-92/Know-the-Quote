//
//  QuotePartModel+Convenience.swift
//  Know the Quote
//
//  Created by macbook on 11/6/20.
//

import CoreData

extension QuotePartModel {
    
    var quotePart: QuotePart {
        get { return QuotePart(rawValue: self.cdValue!)! }  // let (what will return)
        set { self.cdValue = newValue.rawValue }            // var (how can be changed)
    }
}

