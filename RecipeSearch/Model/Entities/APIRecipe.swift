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
    let digest: [Digest]
    let label, image, url: String
    let ingredients: [Ingredient]?
    let calories: Double?
    let healthLabels: [String]
    let totalTime: Int
    let ingredientLines: [String]
    let yield: Int // This indicates the number of servings
    
    enum CodingKeys: String, CodingKey {
        case label, image, url, ingredients, calories, healthLabels, ingredientLines, yield, digest, totalTime
    }
}
// MARK: - Digest
struct Digest: Codable {
    let label: Label
    let total: Double
}
enum Label: String, Codable {
    case calcium = "Calcium"
    case carbohydratesNet = "Carbohydrates (net)"
    case carbs = "Carbs"
    case carbsNet = "Carbs (net)"
    case cholesterol = "Cholesterol"
    case energy = "Energy"
    case fat = "Fat"
    case fiber = "Fiber"
    case folateEquivalentTotal = "Folate equivalent (total)"
    case folateFood = "Folate (food)"
    case folicAcid = "Folic acid"
    case iron = "Iron"
    case magnesium = "Magnesium"
    case monounsaturated = "Monounsaturated"
    case niacinB3 = "Niacin (B3)"
    case phosphorus = "Phosphorus"
    case polyunsaturated = "Polyunsaturated"
    case potassium = "Potassium"
    case protein = "Protein"
    case riboflavinB2 = "Riboflavin (B2)"
    case saturated = "Saturated"
    case sodium = "Sodium"
    case sugarAlcohols = "Sugar alcohols"
    case sugars = "Sugars"
    case sugarsAdded = "Sugars, added"
    case thiaminB1 = "Thiamin (B1)"
    case trans = "Trans"
    case vitaminA = "Vitamin A"
    case vitaminB12 = "Vitamin B12"
    case vitaminB6 = "Vitamin B6"
    case vitaminC = "Vitamin C"
    case vitaminD = "Vitamin D"
    case vitaminE = "Vitamin E"
    case vitaminK = "Vitamin K"
    case water = "Water"
    case zinc = "Zinc"
}
//MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    enum CodingKeys: String, CodingKey {
        case text
    }
}
