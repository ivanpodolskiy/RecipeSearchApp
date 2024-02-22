//
//  SerachScreenBuilder.swift
//  RecipeSearch
//
//  Created by user on 22.02.2024.
//

import UIKit

class SerachScreenBuilder: Builder {
    private var title: String?
    
    func setTitleController(title: String) -> SerachScreenBuilder {
        self.title = title
        return self
    }
    
    func createModule() -> UIViewController {
        let categoryManager = CategoryManager()
        let filterVC = getFilterVC(categoryManager: categoryManager)
       
        let recipesPresenter = getRecipePresenter()
        let recipesCollection = getRecipesCollection(recipesPresenter: recipesPresenter)
        recipesPresenter.attachView(recipesCollection)
        
        let vc = SearchViewController(filterVC: filterVC, recipesCollection: recipesCollection)
        vc.title = title
        
        let searchPresenter = getPreparedPresenter(attach: vc, recipesPresenter: recipesPresenter, categoryManager: categoryManager)
        vc.setPresenter(searchPresenter)
        return vc
    }
    
    private func getRecipesCollection(recipesPresenter: RecipesPresenterProtocol) -> RecipesViewController {
        let recipesCollection = RecipesViewController()
        recipesCollection.setPresenter(recipesPresenter)
       return recipesCollection
    }
    private func getFilterVC(categoryManager: CategoryManager) -> FilterViewController {
        let filterPresenter = FilterPresenter(categoryManager: categoryManager)
        let filterVC = FilterViewController()
        filterVC.setPresenter(filterPresenter)
        filterPresenter.attachView(filterVC)
        return filterVC
    }
    
    private func getPreparedPresenter(attach vc: UIViewController, recipesPresenter: RecipesPresenterProtocol, categoryManager: CategoryManager) -> SearchPresenterProtocol {
        let searchService = RecipeSreachService(networking: NetworkService())
        let alertManager = AlertManager()
        
        let searchPresenter = SearchPresenter(categoryManager: categoryManager, recipeService: searchService, recipesPresenter: recipesPresenter, alertManager: alertManager)
        searchPresenter.attachView(vc)
        return searchPresenter
    }
    
    private func getRecipePresenter() -> RecipesPresenterProtocol {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let favoriteStorage = StorageManagerFR(context: context)
        let favoriteStatusChanger = FavoriteStatusChanger(favoriteRecipesStorage: favoriteStorage)
        
        let recipesPresenter = RecipesPresenter(favoriteStatusChanger:  favoriteStatusChanger)
        return recipesPresenter
    }
}
