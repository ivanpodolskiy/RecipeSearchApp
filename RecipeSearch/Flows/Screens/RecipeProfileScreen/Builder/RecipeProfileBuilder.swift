//
//  ProfileScreenBuilder.swift
//  RecipeSearch
//
//  Created by user on 22.02.2024.
//

import UIKit

class RecipeProfileBuilder: Builder {
    private var favoriteStatusChanger: FavoriteStatusChangerProtocol
    private var recipeProfile: RecipeProfileProtocol
    private var onStatusUpdate: UpdatedStatusCallback?
    
    init(favoriteStatusChanger: FavoriteStatusChangerProtocol, recipeProfile: RecipeProfileProtocol) {
        self.favoriteStatusChanger = favoriteStatusChanger
        self.recipeProfile = recipeProfile
    }
    
    func setCallback(_ onStatusUpdate: @escaping UpdatedStatusCallback) -> RecipeProfileBuilder {
        self.onStatusUpdate = onStatusUpdate
        return self
    }
    
    func createModule() -> UIViewController {
        let recipeDetailVC = createDetailVC()
        let ingredientsView = IngredientsView(cookingInfo: recipeProfile.cookingInfo)
        let categoriesView = CategoriesView(categoriesList: recipeProfile.categories)
       
        let recipeProfileCompositeVC = RecipeProfileCompositeVC(recipeDetailVC: recipeDetailVC, ingredientsView: ingredientsView, categoriesView: categoriesView)
        return recipeProfileCompositeVC
    }
    
    private func createDetailVC() -> RecipeDetailViewController {
        let detailPresenter = getRecipeDetailPresenter()
        
        let recipeProfileDetailVC = RecipeDetailViewController(presenter: detailPresenter)
        detailPresenter.attachView(recipeProfileDetailVC)
        return recipeProfileDetailVC
    }
    
    private func getRecipeDetailPresenter() -> RecipeDetailPresenter {
        let recipeDetailPresenter = RecipeDetailPresenter(favoriteStatusChanger: favoriteStatusChanger, recipeProfile: recipeProfile, onStatusUpdate: onStatusUpdate)
        return recipeDetailPresenter
    }
}
