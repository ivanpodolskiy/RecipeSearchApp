//
//  APIRecipe.swift
//  RecipeSearch
//
//  Created by user on 11.05.2023.
//

import Foundation

// MARK: - Welcome
struct Result: Codable {
   let count: Int
    let hits: [Hit]
    enum CodingKeys: String, CodingKey {
        case count
        case hits
    }
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe?
    enum CodingKeys: String, CodingKey {
        case recipe
    }
}

// MARK: - Recipe
struct Recipe: Codable {
    let label, image: String
    let ingredients: [Ingredient]?
    let calories: Double?
    enum CodingKeys: String, CodingKey {
        case label, image, ingredients, calories
    }
}




// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    enum CodingKeys: String, CodingKey {
        case text
    }
}
