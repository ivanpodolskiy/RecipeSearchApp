//
//  NetworkError.swift
//  RecipeSearch
//
//  Created by user on 22.10.2023.
//

enum DataError {
    case notitems
}
enum NetworkError: Error {
    case noData
    case badURL
    case notFound
    case serverError
    case decodingError
    case badRequest
    case customError(String)
    case unauthorized
    case forbidden
    case unknown(Int)
    case notConnectedToInternet
    case dataError(DataError)
}
