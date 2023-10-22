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
enum SearchTypeError {
    case network
    case data
}

protocol SearchErrorProtocol {
    func displayError(_ userFriendlyDescription: String, type: SearchTypeError)
}
protocol SearchControllerDelegate: AnyObject, SearchErrorProtocol  { }

//MARK: - SearchPresenter
class SearchPresenter: SearchPresenterProtocol {
    weak private var searchControllerDelegate: SearchControllerDelegate!
    private let collectionPresenter: RecipesPresenterProtocol
    private let categoryManager: CategoryManagerProtocol
    private let recipeService: RecipeSearchServiceProtocol
    
    init(categoryManager: CategoryManagerProtocol, recipeService: RecipeSearchServiceProtocol, collectionPresenter: RecipesPresenterProtocol) {
        self.categoryManager = categoryManager
        self.recipeService = recipeService
        self.collectionPresenter = collectionPresenter
    }
    
    func attachView(_ delegate: UIViewController) { searchControllerDelegate = delegate as? SearchControllerDelegate }
    
    func searchRecipes(from searchText: String) {
        recipeService.cancelPreviousRequests()
        if searchText.isEmpty {
            searchControllerDelegate.displayError("Enter a what you have to search, like \"coffee and croissant\" or \"chicken enchilada\" to see how it works.", type: .data)
            return
        }
        let values  = categoryManager.getActiveValues()
        recipeService.searchRecipes(selectedCategories: values, with: searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let recipeArray):
                self.collectionPresenter.updateItemsView(with: recipeArray)
            case .failure(let error):
                switch error {
                case .dataError(.notitems):
                    self.searchControllerDelegate.displayError("Nothing in our recipes database matches what you are searching for! Please try again.", type: .data)
                case .notConnectedToInternet:
                    self.searchControllerDelegate.displayError("The request could not be sent. Checking the network connection.", type: .network)
                default: print("Error: \(error)")
                }
            }
        }
    }
    func createRecpesView() -> UIViewController {
        FactoryElementsView.defaultFactory.createVC(.recipesView, presenter: collectionPresenter)
    }
    
    func createFilterView() -> UIViewController {
        let filterPresnter = FilterPresenter(categoryManager: categoryManager)
        return FactoryElementsView.defaultFactory.createVC(.filterView, presenter: filterPresnter)
    }
}

