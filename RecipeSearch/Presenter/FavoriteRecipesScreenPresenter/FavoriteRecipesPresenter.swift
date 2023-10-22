//
//  FavoriteRecipesPresenter.swift
//  RecipeSearch
//
//  Created by user on 20.10.2023.
//

import Foundation
import CoreData
import UIKit

protocol FavoriteRecipesPresenterProtocol: PresenterProtocol, FavoriteStatusProtocol, RecipeNavigationProtocol, ConfigureCellProtocol {
    func fetchFavoriteRecipes()
    func removeAllRecipes()
}

protocol FavoriteRecipesDelegate: AnyObject, UIViewController, NavigationDelegate {
    func updateCollectionView(favoriteRecipesCategories: [FavoriteCategoryProtocol])
}

class FavoriteRecipesPresenter: FavoriteRecipesPresenterProtocol {
    private let favoriteRecipesStorage: FavoriteRecipesSorageManagerProtocol
    weak var favoriteRecipesController: FavoriteRecipesDelegate?
    
    init(favoriteRecipesStorage: FavoriteRecipesSorageManagerProtocol) {
        self.favoriteRecipesStorage  = favoriteRecipesStorage
    }
    
    func attachView(_ delegate: UIViewController) {
        favoriteRecipesController = delegate as? FavoriteRecipesDelegate
    }
    
    func removeAllRecipes() {
        do {
            try favoriteRecipesStorage.deleteAll()
            favoriteRecipesController?.updateCollectionView(favoriteRecipesCategories: [])
        } catch {
             print (error.localizedDescription)
        }
    }
    
    func configureCell(_ cell: UICollectionViewCell, with recipeProfile: RecipeProfileProtocol, tag: Int) {
        guard let cell = cell as? FavoriteRecipeCell else { return }
        let urlString = recipeProfile.stringImage
        ImageLoader.loadImage(from: urlString) { result in
            switch result {
            case .success( let image) :
                cell.setImage(image)
            case .failure(let error) :
                print ("Error insede RecipesPresenter: \(error.localizedDescription)")
            }
        }
        cell.setupCell(with: recipeProfile)
    }
    
    func fetchFavoriteRecipes() {
        guard let categories = try? favoriteRecipesStorage.getCategories() else { return }
        favoriteRecipesController?.updateCollectionView(favoriteRecipesCategories: categories)
    }
    func changeFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol, with index: Int?) {
        print ("")
    }
    
    func pushResipeScreen(with recipe: RecipeProfileProtocol, onDataUpdate: @escaping ((Any) -> Void)) {
        let presenter = RecipeProfilePresenter(favoriteRecipeStorage: favoriteRecipesStorage, recipeProfile: recipe, onDataUpdate: onDataUpdate)
        let recipeProfileController = FactoryElementsView.defaultFactory.createVC(.profileView, presenter: presenter)
        favoriteRecipesController?.pushViewController(recipeProfileController, animated: true)
    }
}

