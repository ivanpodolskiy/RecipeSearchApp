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
protocol SearchControllerDelegate: AnyObject, UpdatingTextProtocol, PresentAlertDelegate  { }

//MARK: - SearchPresenter
class SearchPresenter: SearchPresenterProtocol {
    weak private var searchControllerDelegate: SearchControllerDelegate!
    private let recipesPresenter: RecipesPresenterProtocol
    private let categoryManager: CategoryManagerProtocol
    private let recipeService: RecipeSearchServiceProtocol
    
    init(categoryManager: CategoryManagerProtocol, recipeService: RecipeSearchServiceProtocol, recipesPresenter: RecipesPresenterProtocol) {
        self.categoryManager = categoryManager
        self.recipeService = recipeService
        self.recipesPresenter = recipesPresenter
    }
    
    func attachView(_ delegate: UIViewController) { searchControllerDelegate = delegate as? SearchControllerDelegate }
    func searchRecipes(from searchText: String) {
        recipeService.cancelPreviousRequests()
        if searchText.isEmpty {
            searchControllerDelegate.updateText("Enter a what you have to search, like \"coffee and croissant\" or \"chicken enchilada\" to see how it works.")
            return
        }
        let values  = categoryManager.getActiveValues()
        recipeService.searchRecipes(selectedCategories: values, with: searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let recipeArray):
                self.recipesPresenter.updateItemsView(with: recipeArray)
            case .failure(let error):
                switch error {
                case .dataError(.notitems):
                    self.searchControllerDelegate.updateText("Nothing in our recipes database matches what you are searching for! Please try again.")
                case .notConnectedToInternet:
                    let alertController = AlertFactory.defaultFactory.getAlertController(type: .notification(title: "Network Error", message: "The request could not be sent. Checking the network connection.", cancelHandler: nil))
                    searchControllerDelegate.presentAlert(alertController)
                default: print("Error: \(error)")
                }
            }
        }
    }
    func createRecpesView() -> UIViewController {
        FactoryElementsView.defaultFactory.createVC(.recipesView, presenter: recipesPresenter)
    }
    
    func createFilterView() -> UIViewController {
        let filterPresnter = FilterPresenter(categoryManager: categoryManager)
        return FactoryElementsView.defaultFactory.createVC(.filterView, presenter: filterPresnter)
    }
}

