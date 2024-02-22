//
//  RPDetailPresenter.swift
//  RecipeSearch
//
//  Created by user on 08.02.2024.
//

import UIKit

protocol RecipeDetailPresenterProtocol: PresenterProtocol, FavoriteStatusProtocol, NavigationWebViewProtocol  {
    func loadData()
    func loadImage()
}
protocol WebErrorProtocol {
    func presentError(_ userFriendlyDescription: String) -> Void
}
protocol RecipeDetailDelegate: AnyObject, UIViewController, NavigationDelegate, WebErrorProtocol, SheetDelegate  {
    func sendDataToController(calories: Int ,macronutrientsInfo: MacronutrientsInfo, favoriteStatus: Bool, title: String)
    func loadImage(_ image: UIImage)
    func updateFavoriteStatus(_ isFavorite: Bool)
}

class RecipeDetailPresenter: RecipeDetailPresenterProtocol {
    private var recipeProfile: RecipeProfileProtocol
    
    weak var delegateView: RecipeDetailDelegate?
    private var onStatusUpdate: UpdatedStatusCallback?
    private var favoriteStatusChanger: FavoriteStatusChangerProtocol
    
    init(favoriteStatusChanger: FavoriteStatusChangerProtocol, recipeProfile: RecipeProfileProtocol, onStatusUpdate:  UpdatedStatusCallback?) {
        self.favoriteStatusChanger = favoriteStatusChanger
        self.recipeProfile = recipeProfile
        self.onStatusUpdate = onStatusUpdate
    }
    
    func attachView(_ view: UIViewController) {
        delegateView = view as? RecipeDetailDelegate
    }
    
    func loadData() {
        let calories = recipeProfile.calories
        let macronutrientsInfo = recipeProfile.macronutrientsInfo
        let favoriteStatus = recipeProfile.isFavorite
        let title = recipeProfile.title
        
        delegateView?.sendDataToController(calories: calories, macronutrientsInfo: macronutrientsInfo, favoriteStatus: favoriteStatus, title: title)
    }
    
    func loadImage() {
        let imageURL = recipeProfile.imageURL
        ImageLoader.loadImage(from: imageURL) { [weak self] result in
            guard let self = self, let image = try? result.get() else { return }
            self.delegateView?.loadImage(image)
        }
    }
    
    func switchFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol? = nil, atIndex index: Int? = nil) {
        favoriteStatusChanger.presentViewControllerClouser =  { [weak self] view  in
            guard let self = self else { return }
            delegateView?.presentCustomSheet(view)
        }
        
        favoriteStatusChanger.toggleFavoriteStatus(recipeProfile) { [weak self] updatedStatus in
            guard let self = self, let updatedStatus = updatedStatus else {return}
            recipeProfile.isFavorite = updatedStatus
            delegateView?.updateFavoriteStatus(updatedStatus)
            onStatusUpdate?(updatedStatus)
        }
    }
    
    func pushWebViewController() -> Void {
        let title = recipeProfile.title
        let url = recipeProfile.url
        if let webViewController = WebViewController(title: title, url: url) {
            delegateView?.pushViewController(webViewController, animated: true)
        } else{
            delegateView?.presentError("Link is not available")
        }
    }
}
