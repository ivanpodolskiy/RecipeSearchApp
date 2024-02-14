//
//  PublicProtocols.swift
//  RecipeSearch
//
//  Created by user on 07.10.2023.
//

import Foundation
import UIKit

//MARK: - PresenterProtocls
typealias UpdatedStatusCallback = (Bool?) -> Void

protocol PresenterProtocol {
    func attachView(_ view: UIViewController)
}
protocol FavoriteStatusProtocol {
    func switchFavoriteStatus(_ selectedRecipe: RecipeProfileProtocol?, atIndex index: Int?)
}
protocol ConfigureCellProtocol {
    func configureCell(_ cell: UICollectionViewCell, with recipeProfile: RecipeProfileProtocol, tag: Int)
}
protocol RecipeNavigationProtocol {
    func pushRecipeProfileScreen(with recipe: RecipeProfileProtocol, onStatusUpdate: UpdatedStatusCallback?)
}

protocol NavigationWebViewProtocol {
    func pushWebViewController() -> Void
}
protocol UpdateStatusProtocol {
    var onStatusUpdate: UpdatedStatusCallback? {get}
}
//MARK: - DelegateProtocols
protocol DelegateViewProtocol {}
protocol NavigationDelegate {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

protocol SheetDelegate {
    func presentCustomSheet(_ viewController: UIViewController)
}
protocol PresentAlertDelegate {
    func presentAlert(_ alert: UIAlertController)
}
