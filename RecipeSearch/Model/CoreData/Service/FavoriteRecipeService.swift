//
//  FavoriteRecipeService.swift
//  RecipeSearch
//
//  Created by user on 29.05.2023.
//

import CoreData
import UIKit

class FavoriteRecipeService {
    func removeRecipe(recipeName: String) {
        guard let favoriteLists = fetchAllCategories() else { return }
        favoriteLists.forEach { category in
            let recipes = category.recipes?.allObjects as! [FavoriteRecipe]
            for recipe in recipes {
                if recipe.title == recipeName {
                    removeRecipe(recipeName: recipeName, categoryName: category.nameCategory!)
                }
            }
        }
    }
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func checkFavoriteStatus(recipes:  [RecipeProfile]) -> [RecipeProfile] {
        guard let categoryies = fetchAllCategories() else { return  recipes }
        var updatedRecipes = recipes
        var index = 0
        
        for recipe in updatedRecipes {
            categoryies.forEach { category in
                guard let favoriteRecipes = category.recipes else { return }
                guard let recipesF = favoriteRecipes.allObjects as? [FavoriteRecipe] else { return }
                for recipeF in recipesF  {
                    guard let title = recipeF.title else { return }
                    if recipe.title == title { updatedRecipes[index].isFavorite = true }
                }
            }
            index += 1
        }
        return updatedRecipes
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
    
    private func convertProfileToFavorite(_ recipeProfile: RecipeProfile) -> FavoriteRecipe {
        let favoriteRecipe = FavoriteRecipe(context: context)
        let title = recipeProfile.title
        let image = recipeProfile.image
        favoriteRecipe.title = title
        favoriteRecipe.image = image
        return favoriteRecipe
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
    
    func fetchAllCategories() -> [FavoriteList]? {
        guard let favoriteLists = try? context.fetch(FavoriteList.fetchRequest()) else { return nil}
        return favoriteLists
    }
    
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = FavoriteList.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? context.execute(batchDeleteRequest1)
        try? context.save()
    }
    
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
    
    func removeRecipe( recipeName: String,  categoryName: String) {
        guard let category = fetchNeededCategory(categoryName) else { return }
        guard var recipes =  category.recipes?.allObjects as? [FavoriteRecipe]  else { return }
        var index = 0
        for recipe in recipes {
            if recipe.title == recipeName {
                context.delete(recipe)
                recipes.remove(at: index)
            }
            index += 1
        }
        try? context.save()
    }
    
    func fetchRecipes(section: Int) -> [FavoriteRecipe]?{
        guard let favoriteLists = fetchAllCategories() else { return nil }
        guard let list = favoriteLists[section].recipes else { return nil }
        do  {
            let recipes =  list.allObjects as! [FavoriteRecipe]
            return recipes
        }
    }
    
    func updateStatusRecipes(for result: inout [RecipeProfile]?) {
        if result != nil {
            let newResult = checkFavoriteStatus(recipes: result!)
            result = newResult
        }
    }
}
