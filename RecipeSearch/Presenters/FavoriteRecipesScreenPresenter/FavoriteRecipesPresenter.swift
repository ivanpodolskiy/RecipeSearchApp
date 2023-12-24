//
//  FavoriteRecipesPresenter.swift
//  RecipeSearch
//
//  Created by user on 20.10.2023.
//

import Foundation
import UIKit


protocol FavoriteSectionCreaterProtocol {
    func addSection()
}
protocol FavoriteRecipesRemoverProtocol{
    func removeRecipe(indexRow: Int, indexSection: Int)
    func removeSection(_ indexSection: Int)
    func removeAllSections()
}
protocol FavoriteRecipesPresenterProtocol: PresenterProtocol, RecipeNavigationProtocol, ConfigureCellProtocol, FavoriteRecipesRemoverProtocol, FavoriteSectionCreaterProtocol {
    func fetchFavoriteRecipes()
    func renameSection(title: String, indexSection: Int)
}

protocol FavoriteRecipesDelegate: AnyObject, UIViewController, NavigationDelegate, PresentAlertDelegate {
    func updateCollectionView(_ updatedData: [FavoriteRecipesSectionProtocol])
    func removeAllSections()
    func removeFavoriteRecipe(section: Int, index: Int, currectFavoriteRecipesCategories: [FavoriteRecipesSectionProtocol] )
    func removeFavoriteSection(indexSection: Int, currentFavoriteSections: [FavoriteRecipesSectionProtocol] )
}

class FavoriteRecipesPresenter: FavoriteRecipesPresenterProtocol {
    private let favoriteRecipesStorage: FavoriteRecipesStorageProtocol
    init(favoriteRecipesStorage: FavoriteRecipesStorageProtocol) { self.favoriteRecipesStorage  = favoriteRecipesStorage }
    
    weak var favoriteRecipesController: FavoriteRecipesDelegate?
    func attachView(_ delegate: UIViewController) {
        favoriteRecipesController = delegate as? FavoriteRecipesDelegate
    }
    
    func configureCell(_ cell: UICollectionViewCell, with recipeProfile: RecipeProfileProtocol, tag: Int) {
        guard let cell = cell as? RecipeCell else { return }
        let urlString = recipeProfile.stringImage
        ImageLoader.loadImage(from: urlString) { result in
            switch result {
            case .success( let image) : cell.setImage(image)
            case .failure(let error) : print ("Error insede RecipesPresenter: \(error.localizedDescription)")
            }
        }
        cell.setupCell(with: recipeProfile, tag: tag)
    }
    
    func fetchFavoriteRecipes() {
        guard let sections = try? favoriteRecipesStorage.fetchSectionArrayFR() else { return }
        favoriteRecipesController?.updateCollectionView(sections)
    }
    
    func renameSection(title: String, indexSection: Int) {
        let sectionArrayCD = try? favoriteRecipesStorage.fetchSectionArrayFR()
        guard let favoriteSection = sectionArrayCD?[indexSection] else { return }
        favoriteRecipesStorage.renameSection(new: title, section: favoriteSection)
    }
}

extension FavoriteRecipesPresenter: FavoriteSectionCreaterProtocol {
    func addSection() {
        let alertController = AlertFactory.defaultFactory.getAlertController(type: .textField(title: "Creating new section", message: "Type name for new section", actionHandler: { [weak self] title in
            guard let self = self, let title = title as? String else { return}
            if favoriteRecipesStorage.addNewSectionCD(with: title) {
                fetchFavoriteRecipes()
            }
        }, cancelHandler: nil))
        favoriteRecipesController?.presentAlert(alertController)
    }
}

extension FavoriteRecipesPresenter: FavoriteRecipesRemoverProtocol {
    private enum MessageRemoving {
        static let all: String  = "Do you want to remove all your favorite recipes"
        static  let one: String = "Do you want to remove this section of recipes?"
    }
    
    func removeSection(_ indexSection: Int) {
        let alertController = AlertFactory.defaultFactory.getAlertController(type: .solution(title: "Removing", message: MessageRemoving.one, actionHandler: { [weak self] header in
            guard let self = self else { return }
            if self.removeSectionFormStorage(indexSection) {
                guard  let currectFavoriteRecipesCategories =  try? favoriteRecipesStorage.fetchSectionArrayFR() else { return }
                favoriteRecipesController?.removeFavoriteSection(indexSection: indexSection, currentFavoriteSections: currectFavoriteRecipesCategories)
            } 
        }, cancelHandler: nil))
        favoriteRecipesController?.presentAlert(alertController)
    }
    func removeRecipe(indexRow: Int, indexSection: Int) {
        let modifiedRecipe = try? favoriteRecipesStorage.fetchSectionArrayFR()
        guard let recipe = modifiedRecipe?[indexSection].recipes?[indexRow] else { return }
        try? favoriteRecipesStorage.removeFavoriteRecipe(recipe)
        guard  let currectFavoriteRecipesCategories =  try? favoriteRecipesStorage.fetchSectionArrayFR() else { return }
        favoriteRecipesController?.removeFavoriteRecipe(section: indexSection, index: indexRow, currectFavoriteRecipesCategories: currectFavoriteRecipesCategories )
    }
    func removeAllSections() {
        let alertController = AlertFactory.defaultFactory.getAlertController(type: .solution(title: "Removing", message: MessageRemoving.all, actionHandler: { [weak self] header in
            guard let self = self else { return }
            try? favoriteRecipesStorage.deleteAll()
            favoriteRecipesController?.removeAllSections()
        }, cancelHandler: nil))
        favoriteRecipesController?.presentAlert(alertController)
    }
    private func removeSectionFormStorage(_ indexSection: Int)  -> Bool { //ref.
       guard let sectionArrayCD = try? favoriteRecipesStorage.fetchSectionArrayFR() else { return false }
        if  indexSection >= 0 && indexSection < sectionArrayCD.count {
            let favoriteSection = sectionArrayCD[indexSection]
            try? favoriteRecipesStorage.removeSectionWithRecipes(favoriteSection)
        } else {
            return false
        }
        return true
    }
}

extension FavoriteRecipesPresenter: RecipeNavigationProtocol {
    func pushRecipeProfileScreen(with recipeProfile: RecipeProfileProtocol, onDataUpdate:  ((Any) -> Void)?) {
        let favoriteStatusManager = FavoriteStatusManager(favoriteRecipesStorage: favoriteRecipesStorage)
        let presenter = RecipeProfilePresenter(favoriteStatusManager: favoriteStatusManager, recipeProfile: recipeProfile, onDataUpdate: onDataUpdate)
        let recipeProfileController = FactoryElementsView.defaultFactory.createVC(.profileView, presenter: presenter)
        favoriteRecipesController?.pushViewController(recipeProfileController, animated: true)
    }
}
