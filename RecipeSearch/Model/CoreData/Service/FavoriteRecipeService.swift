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
    
    //MARK: - Fetch
    func fetchAllCategories() -> [FavoriteList]? {
        do {
            let favoriteLists = try context.fetch(FavoriteList.fetchRequest())
            return favoriteLists
        } catch {
            return nil
        }
    }
    
    func fetchRecipes(section: Int) -> [FavoriteRecipe]?{
        guard let categories = fetchAllCategories(),
                let favoriteRecipes = categories[section].recipes else { return nil }
            let recipes =  favoriteRecipes.allObjects as! [FavoriteRecipe]
            return recipes
    }
    
    func fetchAllTitleCategories() -> [String]?  {
        guard let categories = fetchAllCategories() else { return nil }
        var titles: [String] = []
        for category in categories {
            if let title = category.nameCategory {
                titles.append(title)
            }
        }
        return titles
    }
    
    private func fetchNeededCategory(_ title: String) -> FavoriteList? {
        guard let favoriteLists = try? context.fetch(FavoriteList.fetchRequest()) else { return nil }
        for list in favoriteLists {
            if list.nameCategory == title {
                return list
            }
        }
        return nil
    }
    
    //MARK: - Add
    func addFavoriteRecipe(_ recipeProfile: RecipeProfile, nameCategory: String, сategoryExists: Bool) {
        switch сategoryExists {
        case false :
            let category = FavoriteList(context: context)
            category.nameCategory = nameCategory
            let favoriteRecipe = convertProfileToFavorite(recipeProfile)
            category.addToRecipes(favoriteRecipe)
            try? context.save()
        case true :
            guard let category = fetchNeededCategory(nameCategory) else  { return }
            let favoriteRecipe = convertProfileToFavorite(recipeProfile)
            category.addToRecipes(favoriteRecipe)
            try? context.save()
        }
    }

    //MARK: Remove
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = FavoriteList.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? context.execute(batchDeleteRequest1)
        try? context.save()
    }
    
    func removeRecipe(recipeName: String) {
        guard let favoriteLists = fetchAllCategories() else { return }
        favoriteLists.forEach { category in
            var recipes = category.recipes?.allObjects as! [FavoriteRecipe]
            var index = 0

            for recipe in recipes {
                if recipe.title == recipeName {
                    context.delete(recipe)
                    recipes.remove(at: index)
                }
                index += 1
            }
        }
        try? context.save()

    }
    
    private func removeCategory(_ categoryName: String) {
        guard var favoriteLists = fetchAllCategories() else { return }
        var index = 0
        for category in favoriteLists {
            if  category.nameCategory ==  categoryName {
                favoriteLists.remove(at: index)
            }
            index += 1
        }
        try? context.save()
    }
        
    //MARK: Update
    func updateFavoriteStatus(for result: inout [RecipeProfile]?) {
        if result != nil {
            let newResult = updatingStatus(recipes: result!)
            result = newResult
        }
    }
    
    private func updatingStatus(recipes: [RecipeProfile]) -> [RecipeProfile] {
        guard let categoryies = fetchAllCategories() else { return  recipes }
        var updatedRecipes = recipes
        
        for index in 0..<recipes.count {
            updatedRecipes[index].isFavorite = false
            categoryies.forEach { category in
                guard let favoriteRecipes = category.recipes,
                      let favoriteRecipes = favoriteRecipes.allObjects as? [FavoriteRecipe] else { return }
                
                for favoriteRecipe in favoriteRecipes  {
                    guard let title = favoriteRecipe.title else { return }
                    
                    if updatedRecipes[index].title == title {
                        updatedRecipes[index].isFavorite = true
                        return
                    }
                }
            }
        }
        return updatedRecipes
    }
    
    //MARK: - convert
     private func convertProfileToFavorite(_ recipeProfile: RecipeProfile) -> FavoriteRecipe {
         let favoriteRecipe = FavoriteRecipe(context: context)
         let title = recipeProfile.title
         let image = recipeProfile.image
         favoriteRecipe.title = title
         favoriteRecipe.image = image
         return favoriteRecipe
     }
   
}
