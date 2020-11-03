//
//  User.swift
//  Know the Quote
//
//  Created by macbook on 11/3/20.
//

import Foundation

struct User {
    
    var id =  UUID()
    var username: String
    var password: String
    
    var coins: Int = 0
    var quizesCreated: [UUID]?
    var quizesTakenByID: [UUID]?
}
