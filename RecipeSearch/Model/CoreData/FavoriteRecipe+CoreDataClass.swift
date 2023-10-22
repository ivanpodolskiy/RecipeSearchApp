//
//  FavoriteRecipe+CoreDataClass.swift
//  RecipeSearch
//
//  Created by user on 20.10.2023.
//
//

import Foundation
import CoreData


public class FavoriteRecipe: NSManagedObject {
    convenience init(contex: NSManagedObjectContext, recipeProfile: RecipeProfileProtocol) {
        self.init(context: contex)
        self.image = recipeProfile.stringImage
        self.title = recipeProfile.title
        self.url = recipeProfile.url
        self.totalCalories = Int64(recipeProfile.totalCalories)
        self.healthLabels = recipeProfile.healthLabels
        self.serving = Int64(recipeProfile.serving)
        self.ingredients = recipeProfile.ingredientLines
    }
}
