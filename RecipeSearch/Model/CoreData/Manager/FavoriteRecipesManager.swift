//
//  FavoriteRecipesManager.swift
//  RecipeSearch
//
//  Created by user on 29.05.2023.
//

import CoreData

//MARK: Protocols
protocol FavoriteRecipeCreatingCDProtocol {
    func createRecipeProfileEntity(from recipProfile: RecipeProfileProtocol) throws -> RecipeProfileEntity
}
protocol SectionsFavoriteRecipesFetchingProtocol {
    func fetchSectionArrayFR() throws -> [FavoriteRecipesSectionProtocol]
    func fetchAllTitleSections() -> [String]? //?
}
protocol FavoritRecipeRemoverProtocol {
    func removeFR(_ recipe: RecipeProfileProtocol) throws
    func deleteAll() throws
}
protocol FavoriteRecipesStorageProtocol: SectionsFavoriteRecipesFetchingProtocol, FavoritRecipeRemoverProtocol, FavoriteRecipeCreatingCDProtocol {
    func getUpdatedRecipeArray(from recipe: [RecipeProfileProtocol])throws  -> [RecipeProfileProtocol]
    func addFavoriteRecipe(_ recipeProfileEntity: RecipeProfileEntity, nameSection: String, sectionExists: Bool) throws
    func saveNewSectionCD(with title: String)
}
//MARK: - Storage Manager for Favorite Recipes
class StorageManagerFR: FavoriteRecipesStorageProtocol {
    func createRecipeProfileEntity(from recipeProfile: RecipeProfileProtocol) throws -> RecipeProfileEntity {
       let favoriteRecipe = RecipeProfileEntity(contex: context, recipeProfile: recipeProfile)
       return favoriteRecipe
   }
    
    func addFavoriteRecipe(_ recipeProfileEntity: RecipeProfileEntity, nameSection: String, sectionExists: Bool)  throws {
        switch sectionExists {
        case false :
            let createdSection = try createSectionCD(nameSection)
            createdSection.addToRecipeProfileEntity(recipeProfileEntity)
            try saveContext()
        case true :
            if let sectionCD = try fetchNeededSectionCD(nameSection) {
                sectionCD.addToRecipeProfileEntity(recipeProfileEntity)
                try saveContext()
            }
        }
    }

    
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) { self.context = context }
    
    func saveNewSectionCD(with title: String) {
        let _ = try? createSectionCD(title)
        try? saveContext()
    }
    
    func fetchSectionArrayFR() throws -> [FavoriteRecipesSectionProtocol] {
        guard let favoriteListArray = try fetchSectionArrayCD() else { throw CoreDataError.fetchError}
        var sectionsArray: [FavoriteRecipesSectionProtocol] = []
        favoriteListArray.forEach { favoriteList in
            let sectionFR = FavoriteRecipesSection(from: favoriteList)
            sectionsArray.append(sectionFR)
        }
        return sectionsArray
    }
    func getUpdatedRecipeArray(from recipes: [RecipeProfileProtocol]) throws ->  [RecipeProfileProtocol]  {
        guard let sectionArrayCD = try fetchSectionArrayCD() else { throw CoreDataError.fetchError }
        var updatedRecipes = recipes
        
        for index in 0..<recipes.count {
            var recipe = updatedRecipes[index]
            sectionArrayCD.forEach { sectionCD in
                if let favoriteRecipeArrayCD = sectionCD.recipeProfileEntity as? Set<RecipeProfileEntity> {
                    for favoriteRecipeCD in favoriteRecipeArrayCD {
                        guard let url = favoriteRecipeCD.url else { continue }
                        if recipe.url == url { recipe.isFavorite.toggle() }
                    }
                }
            }
            updatedRecipes[index] = recipe
        }
        return updatedRecipes
    }

    func removeFR(_ recipe: RecipeProfileProtocol) throws {
        guard let sectionArrayCD = try fetchSectionArrayCD() else { throw CoreDataError.fetchError }
        sectionArrayCD.forEach { sectionCD in
            if var favoriteRecipes = sectionCD.recipeProfileEntity as? Set<RecipeProfileEntity>  {
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
    func fetchAllTitleSections() -> [String]? {
            guard let  sectionArrayCD = try? fetchSectionArrayCD() else { return nil}
            var titles: [String] = []
            sectionArrayCD.forEach { sectionCD in
                if let title = sectionCD.nameSection {
                    titles.append(title)
                }
            }
            return titles
    }
    //ref. Remove I want to confirm such operations before executing them.
    func deleteAll() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = RecipesSectionEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do { try context.execute(batchDeleteRequest) } catch { throw CoreDataError.deletionError }
       try saveContext()
    }
    //MARK: Private Fucntions:
    
     private func createSectionCD(_ name: String) throws -> RecipesSectionEntity { //ref.
        let sectionCD = RecipesSectionEntity(context: context)
         sectionCD.nameSection = name
        return sectionCD
    }
    private func fetchSectionArrayCD() throws -> [RecipesSectionEntity]? {
        guard let sectionArrayCD = try? context.fetch(RecipesSectionEntity.fetchRequest()) else { throw CoreDataError.fetchError}
        return sectionArrayCD
    }
    private func fetchNeededSectionCD(_ name: String) throws -> RecipesSectionEntity? {
        guard let sectionArrayCD = try? context.fetch(RecipesSectionEntity.fetchRequest()) else { throw CoreDataError.fetchError }
        for neededSectionCD in sectionArrayCD { if neededSectionCD.nameSection == name { return neededSectionCD } }
        return nil
    }
    private func saveContext() throws {
        do { try context.save() } catch { throw CoreDataError.saveError }
    }
}
