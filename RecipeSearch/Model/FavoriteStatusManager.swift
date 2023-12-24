//
//  FavoriteStatusManager.swift
//  RecipeSearch
//
//  Created by user on 30.11.2023.
//
import UIKit
typealias ChangeStatus = Bool
typealias UpdatedRecipeCallback = (RecipeProfileProtocol?) -> Void

protocol FavoriteStatusManagerProtocol {
    func toggleFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol, completion: @escaping UpdatedRecipeCallback)
    var presentViewControllerClouser: ((UIViewController) -> Void)? {get set}

}
class FavoriteStatusManager: FavoriteStatusManagerProtocol {
    init(favoriteRecipesStorage: FavoriteRecipesStorageProtocol) {
        self.favoriteRecipesStorage = favoriteRecipesStorage
    }
    private var favoriteRecipesStorage: FavoriteRecipesStorageProtocol
 
    var presentViewControllerClouser: ((UIViewController) -> Void)?
    
    func setFavoriteRecipesStorage(_ storage: FavoriteRecipesStorageProtocol) {
           favoriteRecipesStorage = storage
       }

    func toggleFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol, completion: @escaping UpdatedRecipeCallback){
        if selectedRecipe.isFavorite {
            let updatedRecipe = handleRemoveFavorite(selectedRecipe)
            completion(updatedRecipe)
        } else {
            presentSelectionMenu(for: selectedRecipe, completion: completion)
        }
    }
    //MARK: private methods for working favorite status
    private func handleRemoveFavorite(_ recipe: RecipeProfileProtocol) -> RecipeProfileProtocol{
        var modifiedRecipe = recipe
        modifiedRecipe.isFavorite = false
        try? favoriteRecipesStorage.removeFavoriteRecipe(modifiedRecipe)
        return modifiedRecipe
    }
    
    private func presentSelectionMenu(for recipe: RecipeProfileProtocol, completion: @escaping UpdatedRecipeCallback)   {
        guard let presentViewControllerClouser = presentViewControllerClouser else { return  }
        
        lazy var slideInTransitioningDelegate = SelectionSectionManagerView()
        lazy var  selectionView = SelectionMenuVC(titles: favoriteRecipesStorage.fetchAllTitleSections())
        selectionView.transitioningDelegate = slideInTransitioningDelegate
        selectionView.modalPresentationStyle = .custom
        selectionView.completion = { [weak self] selectedPath in
            guard let self = self else { return  }
            if let updatedRecipe = self.handleSelection(selectedPath, for: recipe) { completion(updatedRecipe)
            } else { completion(nil) }
        }
        presentViewControllerClouser(selectionView)
    }
    private func handleSelection(_ select: Selected, for recipe: RecipeProfileProtocol) -> RecipeProfileProtocol? {
        switch select {
        case .oldSection(let name), .newSection(let name):
            let sectionExists = (select == .oldSection(name))
           return handleFavoriteRecipeChange(for: recipe, with: name, sectionExists: sectionExists)
        case .cancel:
            return nil
        }
    }
    
    private func handleFavoriteRecipeChange(for recipe: RecipeProfileProtocol, with name: String, sectionExists: Bool) -> RecipeProfileProtocol?  {
        var modifiedRecipe = recipe
        modifiedRecipe.isFavorite = true
        guard let recipEntity = try? favoriteRecipesStorage.createRecipeProfileEntity(from: modifiedRecipe) else { return nil}
        try? favoriteRecipesStorage.addFavoriteRecipe(recipEntity, nameSection: name, sectionExists: sectionExists)
        return modifiedRecipe
    }
}
