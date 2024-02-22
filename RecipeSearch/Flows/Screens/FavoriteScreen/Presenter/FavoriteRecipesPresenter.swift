//
//  FavoriteRecipesPresenter.swift
//  RecipeSearch
//
//  Created by user on 20.10.2023.
//

import UIKit

//MARK: - Protocols
protocol FavoriteSectionRemoveProtocol {
    func removeSection(_ atIndex: Int)
    func removeAllSections()
}
protocol FavoriteSectionCreaterProtocol {
    func addSection()
}
//// The protocol for managing favorite sections, providing methods for adding, deleting, and renaming sections.
protocol FavoriteSectionProtocol: FavoriteSectionRemoveProtocol,FavoriteSectionCreaterProtocol   {
    func renameSection(_ title: String, atSection: Int)
}

protocol FavoriteRecipesRemoverProtocol{
    func removeRecipe(atRow: Int, atSection: Int)
}

protocol FavoriteRecipesPresenterProtocol: PresenterProtocol, RecipeNavigationProtocol, ConfigureCellProtocol, FavoriteRecipesRemoverProtocol, FavoriteSectionProtocol {
    func fetchFavoriteRecipes()
}
protocol FavoriteRecipesDelegate: AnyObject, UIViewController, NavigationDelegate {
    func updateCollectionView(_ updatedData: [FavoriteRecipesSectionProtocol])
    func removeAllSections()
    func removeFavoriteRecipe(section: Int, index: Int, currectFavoriteRecipesCategories: [FavoriteRecipesSectionProtocol] )
    func removeFavoriteSection(atSection: Int, currentFavoriteSections: [FavoriteRecipesSectionProtocol] )
}

//MARK: - FavoriteRecipesPresenter
class FavoriteRecipesPresenter: FavoriteRecipesPresenterProtocol {
    private let favoriteRecipesStorage: FavoriteRecipesStorageProtocol
    private let alertManager: AlertManagerProtocol
    weak var favoriteRecipesController: FavoriteRecipesDelegate?
    
    init(favoriteRecipesStorage: FavoriteRecipesStorageProtocol, alertManager: AlertManagerProtocol) {
        self.favoriteRecipesStorage  = favoriteRecipesStorage
        self.alertManager = alertManager
    }
    
    func attachView(_ delegate: UIViewController) {
        favoriteRecipesController = delegate as? FavoriteRecipesDelegate
    }
    
    func fetchFavoriteRecipes() {
        guard let sections = try? favoriteRecipesStorage.fetchSectionArrayFR() else { return }
        favoriteRecipesController?.updateCollectionView(sections)
    }
    
    func configureCell(_ cell: UICollectionViewCell, with recipeProfile: RecipeProfileProtocol, tag: Int) {
        guard let cell = cell as? FavoriteRecipeCell else { return }
        let imageURL = recipeProfile.imageURL
        
        ImageLoader.loadImage(from: imageURL) { result in
            switch result {
            case .success( let image) : cell.setImage(image)
            case .failure(let error) : print ("Error insede RecipesPresenter: \(error.localizedDescription)")
            }
        }
        cell.setupCell(with: recipeProfile)

    }
    
    
    func renameSection(_ title: String, atSection: Int) {
        let sectionArrayCD = try? favoriteRecipesStorage.fetchSectionArrayFR()
        guard let favoriteSection = sectionArrayCD?[atSection] else { return }
        favoriteRecipesStorage.renameSection(new: title, section: favoriteSection)
    }
}

extension FavoriteRecipesPresenter: FavoriteSectionCreaterProtocol {
    func addSection() {
        addSectionThroughShowingAlert()
    }
    
    private func addSectionThroughShowingAlert() {
        let alert = AlertFactory.defaultFactory.getCustomAlert(type: .textField(title: "Creating", message: "Type name for new section", actionHandler: { [weak self] title in
            guard let self = self, let title = title as? String else { return}
            createNewScetion(title: title)
        }, cancelHandler: nil, textСheckingHandler: { [weak self] title in
            guard let self = self else  { return false }
            
            if favoriteRecipesStorage.addNewSectionCD(with: title) {
                fetchFavoriteRecipes()
                return true
            }
            return false
        }, errorText: "A section with the same name already exists"))
        
        alertManager.setAlert(alert)
        alertManager.showAlert()
    }
    
    private func createNewScetion(title: String)  {
        if favoriteRecipesStorage.addNewSectionCD(with: title) {
            fetchFavoriteRecipes()
        }
    }
}

fileprivate enum MessageRemoving {
    static let all: String  = "Do you want to remove all your favorite recipes"
    static let single: String = "Do you want to remove this section of recipes?"
}

extension FavoriteRecipesPresenter: FavoriteRecipesRemoverProtocol {
    func removeRecipe(atRow row: Int, atSection section: Int) {
        removeRecipeFromStorage(atRow: row, atSection: section)
        guard  let currectFavoriteRecipesCategories =  try? favoriteRecipesStorage.fetchSectionArrayFR() else { return }
        favoriteRecipesController?.removeFavoriteRecipe(section: section, index: row, currectFavoriteRecipesCategories: currectFavoriteRecipesCategories )
    }
    
    private func removeRecipeFromStorage(atRow: Int, atSection: Int) {
        let modifiedRecipe = try? favoriteRecipesStorage.fetchSectionArrayFR()
        guard let recipe = modifiedRecipe?[atSection].recipes?[atRow] else { return }
        try? favoriteRecipesStorage.removeFavoriteRecipe(recipe)
    }
    
    func removeSection(_ indexSection: Int) {
        removeSectionThroughShowingAlert(alertTitle: "Removing", message: MessageRemoving.single) { [weak self] in
            guard let self = self else { return }
            guard removeSectionFormStorage(indexSection), let currectFavoriteRecipesCategories =  try? favoriteRecipesStorage.fetchSectionArrayFR()
            else { return }
            favoriteRecipesController?.removeFavoriteSection(atSection: indexSection, currentFavoriteSections: currectFavoriteRecipesCategories)
        }
    }
    
    private func removeSectionThroughShowingAlert(alertTitle: String,message: String, removeMethod: @escaping () -> ()) {
        let alert = AlertFactory.defaultFactory.getCustomAlert(type: .solution(title: alertTitle, message: message, actionHandler: { _ in
            removeMethod()
        }, cancelHandler: {
            print ("CANCEL")
        }))
        alertManager.setAlert(alert)
        alertManager.showAlert()
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
   
    func removeAllSections() {
        removeAllSectionThroughShowingAlert(alertTitle: "Removing", message: MessageRemoving.all) { [weak self] in
            guard let self = self else { return }
            try? favoriteRecipesStorage.deleteAll()
            favoriteRecipesController?.removeAllSections()
        }
    }
    
    private func removeAllSectionThroughShowingAlert(alertTitle: String,message: String, removeMethod: @escaping () -> ()) {
        let alert = AlertFactory.defaultFactory.getCustomAlert(type: .solution(title: alertTitle, message: message, actionHandler: {  _ in
            removeMethod()
        }, cancelHandler: nil))
        alertManager.setAlert(alert)
        alertManager.showAlert()
    }
}

extension FavoriteRecipesPresenter: RecipeNavigationProtocol {
    func pushRecipeProfileScreen(with recipe: RecipeProfileProtocol, onStatusUpdate: @escaping UpdatedStatusCallback) {
        let favoriteStatusChanger = FavoriteStatusChanger(favoriteRecipesStorage: favoriteRecipesStorage)
        let profileVC = RecipeProfileBuilder(favoriteStatusChanger: favoriteStatusChanger, recipeProfile: recipe).createModule()
        favoriteRecipesController?.pushViewController(profileVC, animated: true)
    }
}
