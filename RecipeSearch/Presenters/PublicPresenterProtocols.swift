//
//  PublicProtocols.swift
//  RecipeSearch
//
//  Created by user on 07.10.2023.
//

import Foundation
import UIKit

//MARK: - PresenterProtocls
protocol PresenterProtocol {
    func attachView(_ view: UIViewController)
}
protocol FavoriteStatusProtocol {
    func switchFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol?, with index: Int?)
}
protocol RecipeNavigationProtocol {
    func pushRecipeProfileScreen(with recipe: RecipeProfileProtocol, onDataUpdate: ((Any) -> Void)?)
}
protocol ConfigureCellProtocol {
    func configureCell(_ cell: UICollectionViewCell, with recipeProfile: RecipeProfileProtocol, tag: Int)
}
//MARK: - DelegateProtocols
protocol DelegateViewProtocol {}

protocol NavigationDelegate {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

protocol SectionsMenuDelegate {
    func presentFavoriteSectionsView(_ viewController: UIViewController)
}

protocol PresentAlertDelegate {
    func presentAlert(_ alert: UIAlertController)
}