//
//  RecipeProfilePresenter.swift
//  RecipeSearch
//
//  Created by user on 17.09.2023.
//

import Foundation
import UIKit

//MARK: PresenterProtocols
protocol RecipeProfilePresenterProtocol: PresenterProtocol, FavoriteStatusProtocol {
    func pushWebViewController() -> Void
    func loadRecipe()
}
//MARK: DelegateProtocols
protocol WebErrorProtocol {
    func presentError(_ userFriendlyDescription: String) -> Void
}
protocol RecipeProfileDelegate: AnyObject, UIViewController, SectionsMenuDelegate, NavigationDelegate, WebErrorProtocol  {
    func setInfoToViews(recipe: RecipeProfileProtocol)
    func setImage(image: UIImage?)
    func updateFavoriteStatus(isFavorite: Bool)
}
//MARK: - RecipeProfilePresenter
class RecipeProfilePresenter: RecipeProfilePresenterProtocol {
    private var recipeProfile: RecipeProfileProtocol
    private var onDataUpdate: ((Any) -> Void)
    private var favoriteStatusManager: FavoriteStatusManagerProtocol

    weak var recipeProfileDelegateView: RecipeProfileDelegate?
    
    init(favoriteStatusManager: FavoriteStatusManagerProtocol, recipeProfile: RecipeProfileProtocol, onDataUpdate: @escaping ((Any) -> Void) ) {
        self.favoriteStatusManager = favoriteStatusManager
        self.recipeProfile = recipeProfile
        self.onDataUpdate = onDataUpdate
    }
    
    func attachView(_ view: UIViewController) {
        recipeProfileDelegateView = view as? RecipeProfileDelegate
    }
    
    func loadRecipe() {
        let stringImage = recipeProfile.stringImage        
        ImageLoader.loadImage(from: stringImage) { [weak self] result in //ref. может использовать кеширование
            guard let self = self, let image = try? result.get() else {
                self?.recipeProfileDelegateView?.setImage(image: nil)
                return
            }
            self.recipeProfileDelegateView?.setImage(image: image)
        }
        recipeProfileDelegateView?.setInfoToViews(recipe: recipeProfile)
    }
    func pushWebViewController() -> Void {
        let title = recipeProfile.title
        let url = recipeProfile.url
        if let webViewController = WebViewController(title: title, url: url) { recipeProfileDelegateView?.pushViewController(webViewController, animated: true)
        } else{ recipeProfileDelegateView?.presentError("Link is not available") }
    }
    
    func switchFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol? = nil, with index: Int? = nil) {
        favoriteStatusManager.presentViewControllerClouser =  { [weak self] sectionMenu in
            guard let self = self else { return }
            self.recipeProfileDelegateView?.presentCatalogView(sectionMenu)
        }
        favoriteStatusManager.toggleFavoriteStatus(recipeProfile) { [weak self] updatedRecipe in
            guard let self = self, let updatedRecipe = updatedRecipe else {return}
            self.recipeProfile = updatedRecipe
            self.recipeProfileDelegateView?.updateFavoriteStatus(isFavorite: updatedRecipe.isFavorite)
            self.onDataUpdate(updatedRecipe.isFavorite)
        }
    }
}


