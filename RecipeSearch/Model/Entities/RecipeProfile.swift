//
//  RecipeProfile.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

import UIKit

struct RecipeProfile {
    var title: String
    var image: String
    var calories: Int
    var countIngredients: Int
    var healthlabels: [String]?
    var listIngredients: [String]?
    
    var description: String {
        return "Callo. \(calories). Ingre. \(countIngredients) "
    }
}

