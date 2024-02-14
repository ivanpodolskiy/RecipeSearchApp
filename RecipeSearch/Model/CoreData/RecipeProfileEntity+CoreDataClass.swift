//
//  RecipeProfileEntity+CoreDataClass.swift
//  RecipeSearch
//
//  Created by user on 29.11.2023.
//
//

import Foundation
import CoreData


public class RecipeProfileEntity: NSManagedObject {
    convenience init(contex: NSManagedObjectContext, recipeProfile: RecipeProfileProtocol) {
        self.init(context: contex)
        self.image = recipeProfile.imageURL
        self.title = recipeProfile.title
        self.url = recipeProfile.url
        self.totalCalories = Int64(recipeProfile.totalCalories)
        self.healthLabels = recipeProfile.categories
        self.serving = Int64(recipeProfile.cookingInfo.serving)
        self.ingredients = recipeProfile.cookingInfo.ingredients
        self.timeCooking = Int64(recipeProfile.cookingInfo.timeCooking)
        self.proteins = Int64(recipeProfile.macronutrientsInfo.proteins.quantity)
        self.fats = Int64(recipeProfile.macronutrientsInfo.fats.quantity)
        self.carbohydrates = Int64(recipeProfile.macronutrientsInfo.carbohydrates.quantity)        
    }
}
