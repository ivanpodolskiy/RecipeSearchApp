//
//  ModelBuilder.swift
//  RecipeSearch
//
//  Created by user on 22.09.2023.
//

import UIKit

protocol Builder { func createModule() -> UIViewController }

class FavoriteScreenBuilder: Builder {
    private var title: String?
    func setTitleController(title: String) -> FavoriteScreenBuilder {
        self.title = title
        return self
    }
    func createModule() -> UIViewController {
        let view = FavoriteRecipesViewController()
        view.title = title
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let favoriteStorage = StorageManagerFR(context: context)
        let presenter = FavoriteRecipesPresenter(favoriteRecipesStorage: favoriteStorage)
        presenter.attachView(view)
        view.setPresenter(presenter)
        return view
    }  
}
class SerachScreenBuilder: Builder {
    private var title: String?
    func setTitleController(title: String) -> SerachScreenBuilder {
        self.title = title
        return self
    }
    func createModule() -> UIViewController {
        let view = SearchViewController()
        view.title = title
        let searchService = RecipeSreachService()
        let categoryManager = CategoryManager()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let favoriteStorage = StorageManagerFR(context: context)
        let favoriteStatusManager = FavoriteStatusManager(favoriteRecipesStorage: favoriteStorage)
        let recipesPresenter = RecipesPresenter(favoriteRecipesStorage: favoriteStorage, favoriteStatusManager: favoriteStatusManager)
        let searchPresenter = SearchPresenter(categoryManager: categoryManager, recipeService: searchService, recipesPresenter: recipesPresenter)
        searchPresenter.attachView(view)
        view.presenter = searchPresenter
        
        return view
    }
}
