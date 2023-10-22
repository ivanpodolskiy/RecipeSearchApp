//
//  FavoriteRecipesManager.swift
//  RecipeSearch
//
//  Created by user on 29.05.2023.
//

import CoreData

//MARK: Protocols
protocol CategoryFavoritRecipeManagerProtocol {
    func getCategories() throws -> [FavoriteCategoryProtocol]
    func fetchAllTitleCategories() -> [String]?
}
protocol RemoveFavoritRecipeManagerProtocol {
    func removeFavoriteRecipe(_ recipe: RecipeProfileProtocol) throws
    func deleteAll() throws
}
protocol FavoriteRecipesSorageManagerProtocol: CategoryFavoritRecipeManagerProtocol, RemoveFavoritRecipeManagerProtocol {
    func getUpdatedRecipes(from recipe: [RecipeProfileProtocol])throws  -> [RecipeProfileProtocol]
    func addFavoriteRecipe(_ recipeProfile: RecipeProfileProtocol, nameCategory: String, сategoryExists: Bool) throws
}
//MARK: - Manager
class FavoriteRecipesSorageManager: FavoriteRecipesSorageManagerProtocol {
   private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) { self.context = context }

    func getCategories() throws -> [FavoriteCategoryProtocol] {
        guard let favoriteCategories = try fetchAllCategories() else { throw CoreDataError.fetchError}
        var categories: [FavoriteCategoryProtocol] = []
        favoriteCategories.forEach { category in
            var category = FavoriteRecipesCategory(from: category)
            categories.append(category)
        }
        return categories
    }
    func getUpdatedRecipes(from recipes: [RecipeProfileProtocol]) throws ->  [RecipeProfileProtocol]  {
        guard let categoryies = try fetchAllCategories() else { throw CoreDataError.fetchError }
        var updatedRecipes = recipes
        for index in 0..<recipes.count {
            var recipe = updatedRecipes[index]
            categoryies.forEach { category in
                if let favoriteRecipes = category.recipes as? Set<FavoriteRecipe> {
                    for favoriteRecipe in favoriteRecipes {
                        guard let url = favoriteRecipe.url else { continue }
                        if recipe.url == url { recipe.isFavorite.toggle() }
                    }
                }
                
            }
            updatedRecipes[index] = recipe
        }
        return updatedRecipes
    }
    func addFavoriteRecipe(_ recipeProfile: RecipeProfileProtocol, nameCategory: String, сategoryExists: Bool) throws { //methods are doing multiple things
        let favoriteRecipe = try createFavoriteRecipe(from: recipeProfile)
        switch сategoryExists {
        case false :
            let createdCategory = try createFavoriteCategory(nameCategory)
            createdCategory.addToRecipes(favoriteRecipe)
            try saveContext()
        case true :
            if let category = try fetchNeededCategory(nameCategory) {
                category.addToRecipes(favoriteRecipe)
                try saveContext()
            }
        }
    }
    func removeFavoriteRecipe(_ recipe: RecipeProfileProtocol) throws {
        guard let categoryies = try fetchAllCategories() else { throw CoreDataError.fetchError }
        categoryies.forEach { category in
            if var favoriteRecipes = category.recipes as? Set<FavoriteRecipe>  {
                for favoriteRecipe in favoriteRecipes {
                    guard let url = favoriteRecipe.url else { continue }
                    if recipe.url == url {
                        context.delete(favoriteRecipe)
                        favoriteRecipes.remove(favoriteRecipe)
                    }
                }
            }
        }
       try saveContext()
    }
    func fetchAllTitleCategories() -> [String]? {
            guard let  categories = try? fetchAllCategories() else { return nil}
            var titles: [String] = []
            categories.forEach { category in
                if let title = category.nameCategory {
                    titles.append(title)
                }
            }
            return titles
    }
    //ref. Remove I want to confirm such operations before executing them.
    func deleteAll() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteList.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do { try context.execute(batchDeleteRequest1) } catch { throw CoreDataError.deletionError }
       try saveContext()
    }
    //Private Fucntions:
     private func createFavoriteCategory(_ name: String) throws -> FavoriteList { //ref.
        let category = FavoriteList(context: context)
        category.nameCategory = name
        return category
    }
    private func createFavoriteRecipe(from recipeProfile: RecipeProfileProtocol) throws -> FavoriteRecipe {
        let favoriteRecipe = FavoriteRecipe(contex: context, recipeProfile: recipeProfile)
        return favoriteRecipe
    }
    private func saveContext() throws {
        do { try context.save() } catch { throw CoreDataError.saveError }
    }
    private func fetchAllCategories() throws -> [FavoriteList]? {
        guard let categories = try? context.fetch(FavoriteList.fetchRequest()) else { throw CoreDataError.fetchError}
        return categories
    }
    private func fetchNeededCategory(_ name: String) throws -> FavoriteList? {
        guard let categories = try? context.fetch(FavoriteList.fetchRequest()) else { throw CoreDataError.fetchError }
        for category in categories { if category.nameCategory == name { return category } }
        return nil
    }
}
