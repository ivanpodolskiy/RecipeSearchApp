//
//  FavoriteRecipesPresenter.swift
//  RecipeSearch
//
//  Created by user on 20.10.2023.
//

import Foundation
import CoreData
import UIKit

protocol FavoriteRecipesPresenterProtocol: PresenterProtocol, RecipeNavigationProtocol, ConfigureCellProtocol {
    func fetchFavoriteRecipes()
    func removeAllRecipes()
    func remove(with index: Int, section: Int)
    func addSection(title: String)
}

protocol FavoriteRecipesDelegate: AnyObject, UIViewController, NavigationDelegate {
    func updateCollectionView(favoriteRecipesCategories: [FavoriteRecipesSectionProtocol])
    func removeAllSections(currectFavoriteRecipesCategories:  [FavoriteRecipesSectionProtocol])
    func removeFavoriteRecipe(section: Int, index: Int, currectFavoriteRecipesCategories: [FavoriteRecipesSectionProtocol] )
}

class FavoriteRecipesPresenter: FavoriteRecipesPresenterProtocol {
    private let favoriteRecipesStorage: FavoriteRecipesStorageProtocol
    weak var favoriteRecipesController: FavoriteRecipesDelegate?
    
    init(favoriteRecipesStorage: FavoriteRecipesStorageProtocol) {
        self.favoriteRecipesStorage  = favoriteRecipesStorage
    }
    
    func remove(with index: Int, section: Int) {
        let modifiedRecipe = try? favoriteRecipesStorage.fetchSectionArrayFR()
        guard let recipe = modifiedRecipe?[section].recipes?[index] else { return }
        try? favoriteRecipesStorage.removeFR(recipe)
        guard  let currectFavoriteRecipesCategories =  try? favoriteRecipesStorage.fetchSectionArrayFR() else { return }
        favoriteRecipesController?.removeFavoriteRecipe(section: section, index: index, currectFavoriteRecipesCategories: currectFavoriteRecipesCategories )
    }

    func addSection(title: String) {
        favoriteRecipesStorage.saveNewSectionCD(with: title)
        fetchFavoriteRecipes()
    }

    func attachView(_ delegate: UIViewController) {
        favoriteRecipesController = delegate as? FavoriteRecipesDelegate
    }
    
    func removeAllRecipes() {
        do {
            try favoriteRecipesStorage.deleteAll()
            let favoriteRecipesCategories = try favoriteRecipesStorage.fetchSectionArrayFR()
            favoriteRecipesController?.removeAllSections(currectFavoriteRecipesCategories: favoriteRecipesCategories)
        } catch {
             print (error.localizedDescription)
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
    
    func fetchFavoriteRecipes() {
        guard let categories = try? favoriteRecipesStorage.fetchSectionArrayFR() else { return }
        favoriteRecipesController?.updateCollectionView(favoriteRecipesCategories: categories)
    }
 
    func pushResipeScreen(with recipeProfile: RecipeProfileProtocol, onDataUpdate: @escaping ((Any) -> Void)) {
        let favoriteStatusManager = FavoriteStatusManager(favoriteRecipesStorage: favoriteRecipesStorage)
        let presenter = RecipeProfilePresenter(favoriteStatusManager: favoriteStatusManager, recipeProfile: recipeProfile, onDataUpdate: onDataUpdate)
        let recipeProfileController = FactoryElementsView.defaultFactory.createVC(.profileView, presenter: presenter)
        favoriteRecipesController?.pushViewController(recipeProfileController, animated: true)
    }
}

