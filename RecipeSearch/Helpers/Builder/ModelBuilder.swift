//
//  ModelBuilder.swift
//  RecipeSearch
//
//  Created by user on 22.09.2023.
//

import UIKit

protocol Builder { func createModule() -> UIViewController }

class SerachScreenBuilder: Builder {
    private var title: String?
    
    func setTitleController(title: String) -> SerachScreenBuilder {
        self.title = title
        return self
    }
    
    func createModule() -> UIViewController {
        let vc = SearchViewController()
        vc.title = title
        let searchPresenter = getPreparedPresenter(attach: vc)
        vc.setPresenter(searchPresenter)
        return vc
    }
    
    private func getPreparedPresenter(attach vc: UIViewController) -> SearchPresenterProtocol {
        let searchService = RecipeSreachService(networking: NetworkService())
        let categoryManager = CategoryManager()
        let alertManager = AlertManager()
        let recipesPresenter = getRecipePresenter()
        
        let searchPresenter = SearchPresenter(categoryManager: categoryManager, recipeService: searchService, recipesPresenter: recipesPresenter, alertManager: alertManager)
        searchPresenter.attachView(vc)
        return searchPresenter
    }
    
    private func getRecipePresenter() -> RecipesPresenterProtocol {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let favoriteStorage = StorageManagerFR(context: context)
        let favoriteStatusChanger = FavoriteStatusChanger(favoriteRecipesStorage: favoriteStorage)
        
        let recipesPresenter = RecipesPresenter(favoriteRecipesStorage: favoriteStorage, favoriteStatusChanger:  favoriteStatusChanger)
        return recipesPresenter
    }
}

class FavoriteScreenBuilder: Builder {
    private var title: String?
        
    func setTitleController(title: String) -> FavoriteScreenBuilder {
        self.title = title
        return self
    }
    
    func createModule() -> UIViewController {
        let vc = FavoriteRecipesViewController()
        vc.title = title
        let presenter = getPreparedPresenter(attach: vc)
        vc.setPresenter(presenter)
        return vc
    }
    
    private func getPreparedPresenter(attach vc: UIViewController) -> FavoriteRecipesPresenterProtocol {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let favoriteStorage  = StorageManagerFR(context: context)
        let alertManager = AlertManager()
        let presenter = FavoriteRecipesPresenter(favoriteRecipesStorage: favoriteStorage, alertManager: alertManager)
        presenter.attachView(vc)
        return presenter
    }
}
