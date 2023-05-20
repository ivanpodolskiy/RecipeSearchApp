//
//  RecipeProfile.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//
struct RecipeProfile {
    let title: String
    let image: String
    let calories: Int
    let countIngredients: Int
    let recipeInfromation: RecipeInformation
    
    var description: String {
        return "Callo. \(calories). Ingre. \(countIngredients) "
    }
}


