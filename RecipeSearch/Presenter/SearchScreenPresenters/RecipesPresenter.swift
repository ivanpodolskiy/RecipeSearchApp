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
protocol RecipesControllerDelegate: AnyObject, UIViewController, SelectioncategoryDelegate, NavigationDelegate {
    func updateOneItem(recipe: RecipeProfileProtocol, index: Int)
    func updateItems(recipe: [RecipeProfileProtocol]?)
}
//MARK: - RecipesPresenter
class RecipesPresenter: RecipesPresenterProtocol {
    weak var recipeControllerDelegate:  RecipesControllerDelegate?
    private let favoriteRecipeStorage: FavoriteRecipesSorageManagerProtocol
    init(favoriteRecipeStorage: FavoriteRecipesSorageManagerProtocol) {
        self.favoriteRecipeStorage = favoriteRecipeStorage
    }
    func attachView(_ delegate: UIViewController) { recipeControllerDelegate = delegate as? RecipesControllerDelegate }
    func updateItemsView(with recipes:  [RecipeProfileProtocol]) {
        if let updatetRecipes = try? favoriteRecipeStorage.getUpdatedRecipes(from: recipes) {
            var i: Int = 1
            for recipe in updatetRecipes { print("\(i).\(recipe.title)\ncalories:\(recipe.calories)\nlink:\(recipe.url)\nisFavorite:\(recipe.isFavorite)")
                i += 1
            }
            recipeControllerDelegate?.updateItems(recipe: updatetRecipes)
        }
    }
    
    func changeFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol, with index: Int?){
        guard let index = index else { return }
        var modifiedRecipe = selectedRecipe
        
        switch selectedRecipe.isFavorite {
        case true:
            modifiedRecipe.isFavorite = false
            try? favoriteRecipeStorage.removeFavoriteRecipe(modifiedRecipe)
            recipeControllerDelegate?.updateOneItem(recipe: modifiedRecipe, index: index)
            
        case false:
            lazy var slideInTransitioningDelegate = SelectionCategoryManager()
            lazy var  selectionCategoryView = SelectionCategoryView(category: favoriteRecipeStorage.fetchAllTitleCategories())
            selectionCategoryView.transitioningDelegate = slideInTransitioningDelegate
            selectionCategoryView.modalPresentationStyle = .custom
            
            selectionCategoryView.completion = { [weak self] selected in
                guard let self = self else { return  }
                switch selected {
                case .oldCategory(let name):
                    modifiedRecipe.isFavorite = true
                   try? favoriteRecipeStorage.addFavoriteRecipe(modifiedRecipe, nameCategory: name, сategoryExists: true)
                case .newCategory(let name):
                    modifiedRecipe.isFavorite = true
                    try? favoriteRecipeStorage.addFavoriteRecipe(modifiedRecipe, nameCategory: name, сategoryExists: false)
                case .cancel:
                    break
                }
                self.recipeControllerDelegate?.updateOneItem(recipe: modifiedRecipe, index: index)
            }
            recipeControllerDelegate?.presentCatalogView(selectionCategoryView)
        }
    }
    
    func pushResipeScreen(with recipe: RecipeProfileProtocol, onDataUpdate: @escaping ((Any) -> Void)) {
        let presenter = RecipeProfilePresenter(favoriteRecipeStorage: favoriteRecipeStorage, recipeProfile: recipe, onDataUpdate: onDataUpdate)
        let recipeProfileController = FactoryElementsView.defaultFactory.createVC(.profileView, presenter: presenter)
        recipeControllerDelegate?.pushViewController(recipeProfileController, animated: true)
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
}
