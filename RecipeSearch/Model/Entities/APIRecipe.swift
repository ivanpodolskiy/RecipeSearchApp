//
//  APIRecipe.swift
//  RecipeSearch
//
//  Created by user on 11.05.2023.
//
// MARK: - Result
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
    let label, image, url: String
    let ingredients: [Ingredient]?
    let calories: Double?
    let healthLabels: [String]
    let ingredientLines: [String]
    let digest: [Digest]
   // let totaldaily: [String: Total]?
    
    enum CodingKeys: String, CodingKey {
    case label, image, url, ingredients, calories, healthLabels, ingredientLines, digest 
    }
}
// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    enum CodingKeys: String, CodingKey {
        case text
    }
}

struct Digest: Codable {
   // let label: Label
    let tag: String
    //let schemaOrgTag: SchemaOrgTag?
    let total: Double
    let hasRDI: Bool
    let daily: Double
   // let unit: Unit
    //let sub: [Digest]?
}


// MARK: - Total
struct Total: Codable {
   // let label: Label
    let quantity: Double
    //let unit: Unit
}
