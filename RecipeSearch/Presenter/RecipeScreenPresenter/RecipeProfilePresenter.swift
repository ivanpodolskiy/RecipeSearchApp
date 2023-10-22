//
//  RecipeProfilePresenter.swift
//  RecipeSearch
//
//  Created by user on 17.09.2023.
//

import Foundation
import UIKit

//MARK: PresenterProtocols
protocol RecipeProfilePresenterProtocol: PresenterProtocol {
    func pushWebViewController() -> Void
    func loadRecipe()
    func changeFavoriteStatus()
}
//MARK: DelegateProtocols
protocol WebErrorProtocol {
    func presentError(_ userFriendlyDescription: String) -> Void
}
protocol RecipeProfileDelegate: AnyObject, UIViewController, SelectioncategoryDelegate, NavigationDelegate, WebErrorProtocol  {
    func setInfoToViews(recipe: RecipeProfileProtocol)
    func setImage(image: UIImage?)
    func updateFavoriteStatus(isFavorite: Bool)
}
//MARK: - RecipeProfilePresenter
class RecipeProfilePresenter: RecipeProfilePresenterProtocol {
    private let favoriteRecipeStorage: FavoriteRecipesSorageManagerProtocol
    private var recipeProfile: RecipeProfileProtocol
    private var onDataUpdate: ((Any) -> Void)
    
    weak var recipeProfileDelegateView: RecipeProfileDelegate?
    
    init(favoriteRecipeStorage: FavoriteRecipesSorageManagerProtocol, recipeProfile: RecipeProfileProtocol, onDataUpdate: @escaping ((Any) -> Void) ) {
        self.favoriteRecipeStorage = favoriteRecipeStorage
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
    func changeFavoriteStatus() {
        switch recipeProfile.isFavorite {
        case true:
            removeRecipeFromFavorites()
            updateFavoriteStatus()
        case false: showSelectionCategoryView()
        }
    }
    //Private functions:
    private func removeRecipeFromFavorites() {
        recipeProfile.isFavorite = false
        do {
            try favoriteRecipeStorage.removeFavoriteRecipe(recipeProfile)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    private func updateFavoriteStatus() {
        recipeProfileDelegateView?.updateFavoriteStatus(isFavorite: recipeProfile.isFavorite)
        onDataUpdate(recipeProfile.isFavorite)
    }
    private func showSelectionCategoryView() {
        let slideInTransitioningDelegate = SelectionCategoryManager()
        let  selectionCategoryView = SelectionCategoryView(category: favoriteRecipeStorage.fetchAllTitleCategories())
        selectionCategoryView.transitioningDelegate = slideInTransitioningDelegate
        selectionCategoryView.modalPresentationStyle = .custom
        
        selectionCategoryView.completion = { [weak self] selected in
            guard let self = self else { return  }
            if case .oldCategory(let name) = selected { self.updateFavoriteStatusAndAddRecipeToCategory(name: name, categoryExists: true)}
            else if case .newCategory(let name) = selected { self.updateFavoriteStatusAndAddRecipeToCategory(name: name, categoryExists: false)}
        }
        recipeProfileDelegateView?.presentCatalogView(selectionCategoryView)
    }
    private func updateFavoriteStatusAndAddRecipeToCategory(name: String, categoryExists: Bool) {
        recipeProfile.isFavorite = true
        do {
            try favoriteRecipeStorage.addFavoriteRecipe(recipeProfile, nameCategory: name, сategoryExists: categoryExists)
             recipeProfileDelegateView?.updateFavoriteStatus(isFavorite: recipeProfile.isFavorite)
             onDataUpdate(recipeProfile.isFavorite)
        } catch {
            print (error.localizedDescription)
        }
    }
}


