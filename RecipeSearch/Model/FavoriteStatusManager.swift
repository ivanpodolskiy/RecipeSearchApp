//
//  FavoriteStatusManager.swift
//  RecipeSearch
//
//  Created by user on 30.11.2023.
//
import UIKit

protocol FavoriteStatusManagerProtocol {
    func toggleFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol, onStatusUpdate: @escaping UpdatedStatusCallback)
    var presentViewControllerClouser: ((UIViewController) -> Void)? {get set}
}
class FavoriteStatusManager: FavoriteStatusManagerProtocol {
    private var favoriteRecipesStorage: FavoriteRecipesStorageProtocol
    var presentViewControllerClouser: ((UIViewController) -> Void)?

    init(favoriteRecipesStorage: FavoriteRecipesStorageProtocol) {
        self.favoriteRecipesStorage = favoriteRecipesStorage
    }
    
    func toggleFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol, onStatusUpdate: @escaping UpdatedStatusCallback){
        if selectedRecipe.isFavorite {
            let updatedRecipe = handleRemoveFavorite(selectedRecipe)
            onStatusUpdate(updatedRecipe.isFavorite)
        } else {
            presentSelectionMenu(for: selectedRecipe, onStatusUpdate: onStatusUpdate)
        }
    }

    private func handleRemoveFavorite(_ recipe: RecipeProfileProtocol) -> RecipeProfileProtocol{
        var modifiedRecipe = recipe
        modifiedRecipe.isFavorite = false
        try? favoriteRecipesStorage.removeFavoriteRecipe(modifiedRecipe)
        return modifiedRecipe
    }
    private func presentSelectionMenu(for recipe: RecipeProfileProtocol, onStatusUpdate: @escaping UpdatedStatusCallback)   {
        guard let presentViewControllerClouser = presentViewControllerClouser else { return  }
        lazy var slideInTransitioningDelegate = SelectionSectionManagerView()
        
        let  selectionView = SelectionMenuViewController()
        let alertManager = AlertManager()
        let presenter = SelectionMenuPresenter(recipeProfile: recipe, favoriteRecipesStorage: favoriteRecipesStorage, alertManager: alertManager)
        presenter.attachView(selectionView)
        selectionView.setPreseter(presenter: presenter)
        
        selectionView.transitioningDelegate = slideInTransitioningDelegate
        selectionView.modalPresentationStyle = .custom
       
        presenter.onStatusUpdate =  { isFavorite in
            onStatusUpdate(isFavorite)
        }
        presentViewControllerClouser(selectionView)
    }
}
