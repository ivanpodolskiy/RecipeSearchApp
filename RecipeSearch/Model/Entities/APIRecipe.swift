//
//  APIRecipe.swift
//  RecipeSearch
//
//  Created by user on 11.05.2023.
//

import Foundation

struct Welcome: Codable {
    let  count: Int
    let hits: [Hit]
    

    enum CodingKeys: String, CodingKey {
        case   count
        case hits
    }
}

struct Hit: Codable {
    let recipe: Recipe

    enum CodingKeys: String, CodingKey {
        case recipe
    }
}

struct Recipe: Codable {
  let uri, label, image: String
    let dietLabels, healthLabels, cautions, ingredientLines: [String]
}
