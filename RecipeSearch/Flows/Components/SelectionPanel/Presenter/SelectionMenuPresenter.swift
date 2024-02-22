//
//  SelectionMenuPresenter.swift
//  RecipeSearch
//
//  Created by user on 01.01.2024.
//

import UIKit

protocol SelectingProtocol {
    func selectExistingSection(_ titleSection: String)
    func addNewSection()
}
protocol SelectionMenuPresenterProtocol: PresenterProtocol, SelectingProtocol, UpdateStatusProtocol {
    func fetchSectionTitles() -> [String]?
}
protocol SelectionMenuDelegate: AnyObject, DelegateViewProtocol {
    func dismiss()
}

class SelectionMenuPresenter: SelectionMenuPresenterProtocol {
    var onStatusUpdate: UpdatedStatusCallback?
    private var recipeProfile: RecipeProfileProtocol
    private let alertManager: AlertManagerProtocol
    private let favoriteRecipesStorage: FavoriteRecipesStorageProtocol
    
    weak var selectionMenu: SelectionMenuDelegate?

    init(recipeProfile: RecipeProfileProtocol, favoriteRecipesStorage: FavoriteRecipesStorageProtocol,  alertManager: AlertManagerProtocol) {
        self.favoriteRecipesStorage = favoriteRecipesStorage
        self.recipeProfile = recipeProfile
        self.alertManager = alertManager
    }
    
    func attachView(_ view: UIViewController) {
        selectionMenu = view as? SelectionMenuDelegate
    }
    
    func fetchSectionTitles() -> [String]? {
        guard let sectionTitles = favoriteRecipesStorage.fetchAllTitleSections() else { return nil }
        return sectionTitles
    }
    
    func selectExistingSection(_ sectionTitle: String) {
        try? addRecipeToStorage(recipeProfile, toSection: sectionTitle)
        onStatusUpdate?(true)
        selectionMenu?.dismiss()
    }

    private func addRecipeToStorage(_ recipeProfile: RecipeProfileProtocol, toSection sectionTitle: String) throws {
        try? favoriteRecipesStorage.addFavoriteRecipe(recipeProfile, nameSection: sectionTitle, sectionExists: true)
    }
    
    func addNewSection() {
        addSectionThroughShowingAlert(alertTitle: "Creating", message: "Type name for new section") { [weak self] title in
            guard let self = self else { return }
            try? favoriteRecipesStorage.addFavoriteRecipe(recipeProfile, nameSection: title, sectionExists: true)
            onStatusUpdate?(true)
            selectionMenu?.dismiss()
        }
    }
    
    private func addSectionThroughShowingAlert(alertTitle: String, message: String, addMethod: @escaping (String) -> ()) {
        let alert = AlertFactory.defaultFactory.getCustomAlert(type: .textField(title: alertTitle, message: message, actionHandler: { titleSelectedSection in
            guard let title = titleSelectedSection as? String else { return}
            addMethod(title)
        }, cancelHandler: nil, textСheckingHandler: { [weak self] title in
            guard let self = self else  { return false }
            return favoriteRecipesStorage.addNewSectionCD(with: title)
        }, errorText: "A section with the same name already exists"))
        alertManager.setAlert(alert)
        alertManager.showAlert()
    }
}
