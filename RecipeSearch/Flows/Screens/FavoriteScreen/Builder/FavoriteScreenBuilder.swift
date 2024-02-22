//
//  FavoriteScreenBuilder.swift
//  RecipeSearch
//
//  Created by user on 22.02.2024.
//

import UIKit

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
