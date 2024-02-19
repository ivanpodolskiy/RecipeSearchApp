//
//  URLBuilder.swift
//  RecipeSearch
//
//  Created by user on 14.02.2024.
//
import Foundation
protocol APIProtocol {
    var baseURL: String {get }
    var appID: String { get }
    var appKey: String { get }
}
fileprivate struct EdamamAPI: APIProtocol {
    let baseURL = "https://api.edamam.com/api/recipes/v2"
    let appID = "71021edf"
    let appKey = "389c0530b12807d2bd5033fb2694567c"
}

class URLBuilder {
    private let apiData: APIProtocol
    init(apiData: APIProtocol) {
        self.apiData = apiData
    }
    
    convenience init() {
        self.init(apiData: EdamamAPI())
    }
    
    func buildURL(with text: String, categoryValues: [CategoryValueProtocol]?) -> URL? {
        guard var urlComponents = URLComponents(string: apiData.baseURL) else { return nil }
        
         var queryItems = [
             URLQueryItem(name: "type", value: "any"),
             URLQueryItem(name: "app_id", value: apiData.appID),
             URLQueryItem(name: "app_key", value: apiData.appKey),
             URLQueryItem(name: "q", value: text),
         ]

         if let values = categoryValues {
             values.forEach { value in
                 queryItems.append(URLQueryItem(name: value.type.rawValue, value: value.title))
             }
         }

         urlComponents.queryItems = queryItems
         return urlComponents.url
     }
}
