//
//  FavoriteStatusChanger.swift
//  RecipeSearch
//
//  Created by user on 30.11.2023.
//
import UIKit

protocol FavoriteStatusChangerProtocol {
    var presentViewControllerClouser: ((UIViewController) -> Void)? {get set}
    func toggleFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol, onStatusUpdate: @escaping UpdatedStatusCallback)
}

class FavoriteStatusChanger: FavoriteStatusChangerProtocol {
    var presentViewControllerClouser: ((UIViewController) -> Void)?
    private var favoriteRecipesStorage: FavoriteRecipesStorageProtocol
    
    init(favoriteRecipesStorage: FavoriteRecipesStorageProtocol) {
        self.favoriteRecipesStorage = favoriteRecipesStorage
    }
    
    func toggleFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol, onStatusUpdate: @escaping UpdatedStatusCallback){
        if selectedRecipe.isFavorite {
            let updatedRecipe = handleRemoveFavoriteStatus(selectedRecipe)
            onStatusUpdate(updatedRecipe.isFavorite)
        } else {
            presentSelectionMenu(for: selectedRecipe, onStatusUpdate: onStatusUpdate)
        }
    }
    
    private func handleRemoveFavoriteStatus(_ recipe: RecipeProfileProtocol) -> RecipeProfileProtocol{
        var modifiedRecipe = recipe
        modifiedRecipe.isFavorite = false
        try? favoriteRecipesStorage.removeFavoriteRecipe(modifiedRecipe)
        return modifiedRecipe
    }
    
    private func presentSelectionMenu(for recipe: RecipeProfileProtocol, onStatusUpdate: @escaping UpdatedStatusCallback)   {
        guard let presentViewControllerClouser = presentViewControllerClouser else { return  }
        let  selectionVC = SelectionPanelViewController()
        let presenter = getPreparedPresenter(attach: selectionVC, recipe: recipe, callback: onStatusUpdate)
        selectionVC.setPresenter(presenter: presenter)
        
        presentViewControllerClouser(selectionVC)
    }
    
    private func getPreparedPresenter(attach vc: UIViewController, recipe: RecipeProfileProtocol, callback : @escaping UpdatedStatusCallback) -> SelectionMenuPresenterProtocol {
        let alertManager = AlertManager()
        
        let presenter = SelectionMenuPresenter(recipeProfile: recipe, favoriteRecipesStorage: favoriteRecipesStorage, alertManager: alertManager)
        presenter.attachView(vc)
        presenter.onStatusUpdate =  { isFavorite in
            callback(isFavorite)
        }
        return presenter
    }
}
