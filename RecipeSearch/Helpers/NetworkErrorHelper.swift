//
//  NetworkErrorHelper.swift
//  RecipeSearch
//
//  Created by user on 04.10.2023.
//

enum NetworkErrorHelper {
    static func handlerStatusCode(_ statusCode: Int) -> NetworkError? {
        switch statusCode {
        case 200...299: return nil
        case 400: return .badRequest
        case 401: return  .unauthorized
        case 403: return   .forbidden
        case 404: return  .notFound
        case 500...599: return  .serverError
        default: return .unknown(statusCode)
        }
    }
}


