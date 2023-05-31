//
//  FavoriteRecipeService.swift
//  RecipeSearch
//
//  Created by user on 29.05.2023.
//

import CoreData
import UIKit

class FavoriteRecipeService {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
        func updateStatusRecipes(for result: inout [RecipeProfile]? ) {
       if result != nil {
           let newResult = checkFavoriteStatus(recipes: result!)
           result = newResult
       }
   }
    func addFavoriteRecipe(_ recipe: RecipeProfile) {
       let favoriteRecipe = FavoriteRecipes(context: self.context)
       favoriteRecipe.title = recipe.title
       try? context.save()
   }
    
     func removeFavotireRecipe(name: String) {
         let favoriteRecipesList = fetchFavoriteRecipes()

        for item in favoriteRecipesList {
          if  item.title == name {
              removeFavotireRecipe(item)
              break }
        }
    }
     func fetchFavoriteRecipes() -> [FavoriteRecipes] {
        do {
            let favoriteRecipesList = try context.fetch(FavoriteRecipes.fetchRequest())
            return favoriteRecipesList

        } catch {
            return []
        }
    }

    private func removeFavotireRecipe(_ removeRecpe: FavoriteRecipes) {
        do {
            context.delete(removeRecpe)
            try context.save()
        } catch {
        }
    }

    private func checkFavoriteStatus(recipes:  [RecipeProfile]) -> [RecipeProfile] {
        let favoriteRecipesList = fetchFavoriteRecipes()
        var far = recipes
        var i = 0
        for recipe in far {
            favoriteRecipesList.forEach({ favoriteRecipe in
                if favoriteRecipe.title == recipe.title {
                    far[i].isFavorite = true
                }
                i += 1
            })
        }
       return far
    }
}

