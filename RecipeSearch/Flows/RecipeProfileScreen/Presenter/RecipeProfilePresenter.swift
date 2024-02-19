//
//  RecipeProfilePresenter.swift
//  RecipeSearch
//
//  Created by user on 17.09.2023.
//

import UIKit

//MARK: PresenterProtocols
protocol RecipeProfilePresenterProtocol: PresenterProtocol  {
    func loadData()
}
//MARK: DelegateProtocol
protocol RecipeProfileDelegate: AnyObject, UIViewController {
    func loadData(categoriesList: [String], cookingInfo: CookingInfo)
}
//MARK: - RecipeProfilePresenter
class RecipeProfilePresenter: RecipeProfilePresenterProtocol {
    weak var recipeProfileDelegateView: RecipeProfileDelegate?
    private let recipeProfile: RecipeProfileProtocol
    
    init(recipeProfile: RecipeProfileProtocol) {
        self.recipeProfile = recipeProfile
    }
    
    func attachView(_ view: UIViewController) {
        recipeProfileDelegateView = view as? RecipeProfileDelegate
    }
    
    func loadData() {
        let categories = recipeProfile.categories
        let cookingInfo = recipeProfile.cookingInfo
        recipeProfileDelegateView?.loadData(categoriesList: categories, cookingInfo: cookingInfo)
    }
}
