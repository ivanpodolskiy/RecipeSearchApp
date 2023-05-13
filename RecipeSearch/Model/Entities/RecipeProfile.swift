//
//  RecipeProfile.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

import Foundation
import UIKit

struct RecipeProfile {
    var title: String
    var image: String
    var calories: Int
    var countIngredient: Int
    
    var description: String {
        return "Callo. \(calories). Ingre. \(countIngredient) "
    }
    
}

