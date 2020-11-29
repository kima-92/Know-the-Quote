//
//  NetworkingError.swift
//  Know the Quote
//
//  Created by macbook on 11/20/20.
//

import Foundation

enum NetworkingError: Error {
    case noData
    case serverError(Error)
    case unexpectedStatusCode(Int)
    case badDecode
    case badEncode
    case notAddedToFirebase
    case noRepresentation
    case noBaseURL
}
