//
//  FavoriteRecipesManager.swift
//  RecipeSearch
//
//  Created by user on 29.05.2023.
//

import CoreData

//MARK: Protocols
protocol FavoriteRecipeСhangeProtocol {
    func renameSection(new: String, section: FavoriteRecipesSectionProtocol)
}

protocol SectionsFavoriteRecipesFetchingProtocol {
    func fetchSectionArrayFR() throws -> [FavoriteRecipesSectionProtocol]
    func fetchAllTitleSections() -> [String]? //?
}
protocol FavoritRecipeRemoverProtocol {
    func removeFavoriteRecipe(_ recipe: RecipeProfileProtocol) throws
    func deleteAll() throws
    func removeSectionWithRecipes(_  favoriteRecipeSection: FavoriteRecipesSectionProtocol) throws
}
protocol FavoriteRecipesStorageProtocol: SectionsFavoriteRecipesFetchingProtocol, FavoritRecipeRemoverProtocol , FavoriteRecipeСhangeProtocol{
    func addFavoriteRecipe(_ recipeProfile: RecipeProfileProtocol, nameSection: String, sectionExists: Bool) throws
    func addNewSectionCD(with title: String) -> Bool
}
//MARK: - Storage Manager for Favorite Recipes
class StorageManagerFR: FavoriteRecipesStorageProtocol {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) { self.context = context }
    
    func renameSection(new: String, section: FavoriteRecipesSectionProtocol) {
        let sectionCD = try? fetchNeededSectionCD(section.title)
        sectionCD?.nameSection = new
        try? saveContext()
    }
    
    
    
    func addFavoriteRecipe(_ recipeProfile: RecipeProfileProtocol, nameSection: String, sectionExists: Bool)  throws {
        let recipeProfileEntity = try createRecipeProfileEntity(from: recipeProfile)
        
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
        }}
    private  func createRecipeProfileEntity(from recipeProfile: RecipeProfileProtocol) throws -> RecipeProfileEntity {
        let favoriteRecipe = RecipeProfileEntity(contex: context, recipeProfile: recipeProfile)
        return favoriteRecipe
    }
    
    func addNewSectionCD(with title: String) -> Bool {
        do {
            try creatingnCheck(title)
            let _ = try createSectionCD(title)
            try saveContext()
            return true
        }
        catch {
            return false
        }
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
    
    func removeSectionWithRecipes(_ favoriteRecipeSection: FavoriteRecipesSectionProtocol) throws {
        guard let sectionArrayCD = try fetchSectionArrayCD() else { throw CoreDataError.fetchError}
        sectionArrayCD.forEach { sectionCD in
            if sectionCD.nameSection == favoriteRecipeSection.title {
                context.delete(sectionCD)
            }
        }
        try saveContext()
    }
    
    func removeFavoriteRecipe(_ recipe: RecipeProfileProtocol) throws {
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
    private func creatingnCheck(_ title: String) throws {
        if (try? fetchNeededSectionCD(title)) != nil { throw CoreDataError.addSectionError  }
    }
    
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