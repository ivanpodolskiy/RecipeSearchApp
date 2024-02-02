//
//  RecipeCollectionPresenter.swift
//  RecipeSearch
//
//  Created by user on 09.10.2023.
//

import Foundation
import UIKit

//MARK: Presenter Protocols
protocol RecipesPresenterProtocol: PresenterProtocol, RecipeNavigationProtocol, FavoriteStatusProtocol, ConfigureCellProtocol{
    func updateItemsView(with recipes: [RecipeProfileProtocol])
}
//MARK: Delegate Protocols
protocol RecipesControllerDelegate: AnyObject, SheetDelegate, NavigationDelegate {
    func updateFavoriteStatus(isFavorite: Bool, index: Int)
    func updateItems(recipe: [RecipeProfileProtocol]?)
}
//MARK: - RecipesPresenter
class RecipesPresenter: RecipesPresenterProtocol {
    private let favoriteRecipesStorage: FavoriteRecipesStorageProtocol
    private var favoriteStatusManager: FavoriteStatusManagerProtocol
    weak var recipeControllerDelegate:  RecipesControllerDelegate?

    init(favoriteRecipesStorage: FavoriteRecipesStorageProtocol, favoriteStatusManager: FavoriteStatusManagerProtocol) {
        self.favoriteRecipesStorage = favoriteRecipesStorage
        self.favoriteStatusManager = favoriteStatusManager
    }
    
    func attachView(_ delegate: UIViewController) { 
        recipeControllerDelegate = delegate as? RecipesControllerDelegate
    }

    func updateItemsView(with recipes:  [RecipeProfileProtocol]) {
        if let updatetRecipes = try? favoriteRecipesStorage.getUpdatedRecipeArray(from: recipes) {
            recipeControllerDelegate?.updateItems(recipe: updatetRecipes)
        }
    }
    
    func switchFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol?, with index: Int?) {
        guard let selectedRecipe = selectedRecipe, let index = index else { return }
        favoriteStatusManager.presentViewControllerClouser = {[ weak self] viewController  in
            guard let self = self else { return }
            self.recipeControllerDelegate?.presentCustomSheet(viewController)
        }
        favoriteStatusManager.toggleFavoriteStatus(selectedRecipe) { [weak self] updatedStatus in
            guard let self = self,  let updatedStatus = updatedStatus else { return }
            self.recipeControllerDelegate?.updateFavoriteStatus(isFavorite: updatedStatus, index: index)
        }
    }
    
    func configureCell(_ cell: UICollectionViewCell, with recipeProfile: RecipeProfileProtocol, tag: Int) {
        guard let cell = cell as? RecipeCell else { return }
        let urlString = recipeProfile.stringImage
        ImageLoader.loadImage(from: urlString) { result in
            switch result {
            case .success( let image) :
                cell.setImage(image)
            case .failure(let error) :
                print ("Error insede RecipesPresenter: \(error.localizedDescription)")
            }
        }
        cell.setupCell(with: recipeProfile, tag: tag)
    }
    
    func pushRecipeProfileScreen(with recipe: RecipeProfileProtocol, onStatusUpdate: UpdatedStatusCallback?) {
        let presenter = RecipeProfilePresenter(favoriteStatusManager: favoriteStatusManager, recipeProfile: recipe, onStatusUpdate: onStatusUpdate)
        let recipeProfileController = ElementsViewFactory.defaultFactory.createVC(.profileView, presenter: presenter)
        recipeControllerDelegate?.pushViewController(recipeProfileController, animated: true)
    }
}
