//
//  Quiz.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import UIKit

struct Quiz {
    
    var id = UUID()
    var title: String
    var dateCreated = Date()
    var creatorID = UUID()
    
    var quotes: [Quote]
    var image: UIImage
    var hasBeenReported = false
}
