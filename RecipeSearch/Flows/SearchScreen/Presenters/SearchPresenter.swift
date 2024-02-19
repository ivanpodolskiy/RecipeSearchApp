//
//  SearchPresenter.swift
//  RecipeSearch
//
//  Created by user on 09.10.2023.
//

import Foundation
import UIKit

//MARK: - PresenterProtocols
protocol CreaterProtocol {
    func createRecpesView() -> UIViewController
    func createFilterView() -> UIViewController
}
protocol SearchPresenterProtocol: PresenterProtocol, CreaterProtocol  {
    func searchRecipes(from searchText: String)
}
//MARK: - DelegateProtcols
protocol UpdatingTextProtocol {
    func updateText(_ userFriendlyDescription: String)
}
protocol SearchControllerDelegate: AnyObject, UpdatingTextProtocol  { }

fileprivate enum LabelText {
    static let launch: String  = "Enter a what you have to search, like \"coffee and croissant\" or \"chicken enchilada\" to see how it works."
    static let recipeNotFound: String = "Nothing in our recipes database matches what you are searching for! Please try again."
}

class SearchPresenter: SearchPresenterProtocol {
    private let recipesPresenter: RecipesPresenterProtocol
    private let categoryManager: CategoryManagerProtocol
    private let recipeService: RecipeSearchServiceProtocol
    private let alertManager: AlertManagerProtocol
    weak private var searchControllerDelegate: SearchControllerDelegate!
    
    init(categoryManager: CategoryManagerProtocol, recipeService: RecipeSearchServiceProtocol, recipesPresenter: RecipesPresenterProtocol, alertManager: AlertManagerProtocol) {
        self.categoryManager = categoryManager
        self.recipeService = recipeService
        self.recipesPresenter = recipesPresenter
        self.alertManager = alertManager
    }
    
    func attachView(_ delegate: UIViewController) { searchControllerDelegate = delegate as? SearchControllerDelegate }
   
    func createRecpesView() -> UIViewController {
        let recipesVC = VCFactory.defaultFactory.createVC(.recipesVC, presenter: recipesPresenter)
        return recipesVC
    }
    
    func createFilterView() -> UIViewController {
        let filterPresnter = FilterPresenter(categoryManager: categoryManager)
        let filterVC = VCFactory.defaultFactory.createVC(.filterVC, presenter: filterPresnter)
        return filterVC
    }
    
    func searchRecipes(from searchText: String) {
        let activeCaregories  = categoryManager.getActiveValues()
        guard !searchText.isEmpty else {
            searchControllerDelegate.updateText(LabelText.launch)
            return
        }
        
        recipeService.searchRecipes(selectedCategories: activeCaregories, with: searchText) {  [weak self] result in
            guard let self = self else { return }
            updateDataWithResult(result)
        }
    }
    
    private func updateDataWithResult(_ result: Result<[RecipeProfileProtocol], NetworkError>) {
        switch result {
        case .success(let recipeArray):
            self.recipesPresenter.updateItemsView(with: recipeArray)
        case .failure(let error):
            switch error {
            case .dataError(.notitems):
                searchControllerDelegate.updateText(LabelText.recipeNotFound)
            case .notConnectedToInternet:
                showErrorAlert(alertTitle: "Network Error", errorMessage: "The request could not be sent. Checking the network connection.")
            default: print("Error: \(error)")
            }
        }
    }
    
    private func showErrorAlert(alertTitle: String, errorMessage: String) {
        let alert = AlertFactory.defaultFactory.getCustomAlert(type: .notification(title: alertTitle, message: errorMessage))
        alertManager.setAlert(alert)
        alertManager.showAlert()
    }
}
