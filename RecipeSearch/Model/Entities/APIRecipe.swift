//
//  APIRecipe.swift
//  RecipeSearch
//
//  Created by user on 11.05.2023.
//
// MARK: - RecipesResult
struct RecipesResult: Codable {
   let count: Int
    let hits: [Hit]
    enum CodingKeys: String, CodingKey {
        case count
        case hits
    }
}
//MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe?
    enum CodingKeys: String, CodingKey {
        case recipe
    }
}
//MARK: - Recipe
struct Recipe: Codable {
    let label, image, url: String
    let ingredients: [Ingredient]?
    let calories: Double?
    let healthLabels: [String]
    let ingredientLines: [String]
    let yield: Int // This indicates the number of servings
    enum CodingKeys: String, CodingKey {
        case label, image, url, ingredients, calories, healthLabels, ingredientLines, yield
    }
}
//MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    enum CodingKeys: String, CodingKey {
        case text
    }
}
