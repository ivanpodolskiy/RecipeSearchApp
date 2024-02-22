//
//  RecipeCollectionPresenter.swift
//  RecipeSearch
//
//  Created by user on 09.10.2023.
//

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
    private var favoriteStatusChanger: FavoriteStatusChangerProtocol
    weak var recipesCollectionDelegate:  RecipesControllerDelegate?

    init(favoriteStatusChanger: FavoriteStatusChangerProtocol) {
        self.favoriteStatusChanger = favoriteStatusChanger
    }
    
    func attachView(_ delegate: UIViewController) { 
        recipesCollectionDelegate = delegate as? RecipesControllerDelegate
    }

    func updateItemsView(with recipes:  [RecipeProfileProtocol]) {
        if let updatetRecipes = try? favoriteStatusChanger.updateRecipesWithFavoriteStatus(from: recipes) {
            recipesCollectionDelegate?.updateItems(recipe: updatetRecipes)
        }
    }
    
    func switchFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol?, atIndex index: Int?) {
        guard let selectedRecipe = selectedRecipe, let index = index else { return }
        favoriteStatusChanger.presentViewControllerClouser = {[ weak self] viewController  in
            guard let self = self else { return }
            self.recipesCollectionDelegate?.presentCustomSheet(viewController)
        }
        favoriteStatusChanger.toggleFavoriteStatus(selectedRecipe) { [weak self] updatedStatus in
            guard let self = self,  let updatedStatus = updatedStatus else { return }
            self.recipesCollectionDelegate?.updateFavoriteStatus(isFavorite: updatedStatus, index: index)
        }
    }
    
    func configureCell(_ cell: UICollectionViewCell, with recipeProfile: RecipeProfileProtocol, tag: Int) {
        guard let cell = cell as? RecipeCell else { return }
        let urlString = recipeProfile.imageURL
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
    
    func pushRecipeProfileScreen(with recipeProfile: RecipeProfileProtocol, onStatusUpdate: @escaping UpdatedStatusCallback) {

        let profileVC = RecipeProfileBuilder(favoriteStatusChanger: favoriteStatusChanger, recipeProfile: recipeProfile).setCallback(onStatusUpdate).createModule()
        recipesCollectionDelegate?.pushViewController(profileVC, animated: true)
    }
}
