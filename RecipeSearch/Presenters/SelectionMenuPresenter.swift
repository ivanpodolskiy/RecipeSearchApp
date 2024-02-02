//
//  SelectionMenuPresenter.swift
//  RecipeSearch
//
//  Created by user on 01.01.2024.
//

import UIKit

protocol SelectingProtocol {
    func selectExistingSection(_ title: String)
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
        return favoriteRecipesStorage.fetchAllTitleSections()
    }
    
    func selectExistingSection(_ title: String) {
        guard let recipeeEntity = try? favoriteRecipesStorage.createRecipeProfileEntity(from: recipeProfile) else { return }
        try? favoriteRecipesStorage.addFavoriteRecipe(recipeeEntity, nameSection: title, sectionExists: true)
        onStatusUpdate?(true)
        selectionMenu?.dismiss()
    }
    
    func addNewSection() {
        let alert = AlertFactory.defaultFactory.getCustomAlert(type: .textField(title: "Creating", message: "Type name for new section", actionHandler: { [weak self] title  in
            guard let self = self , let title = title as? String else { return}
            guard let recipeeEntity = try? favoriteRecipesStorage.createRecipeProfileEntity(from: recipeProfile) else { return }
            try? favoriteRecipesStorage.addFavoriteRecipe(recipeeEntity, nameSection: title, sectionExists: true)
            
            onStatusUpdate?(true)
            selectionMenu?.dismiss()
        }, cancelHandler: nil, textСheckingHandler: { [weak self] title in
            guard let self = self else  { return false }
            return favoriteRecipesStorage.addNewSectionCD(with: title)
        }, errorText: "A section with the same name already exists"))
        alertManager.setAlert(alert)
        alertManager.showAlert()
    }
}
