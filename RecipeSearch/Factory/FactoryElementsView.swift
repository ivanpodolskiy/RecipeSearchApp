//
//  Factory.swift
//  RecipeSearch
//
//  Created by user on 22.09.2023.
//

import UIKit

protocol FactoryProtocol {
    func createPreparedView() -> UIViewController
}

enum ElementView {
    case filterView
    case recipesView
    case profileView
}
class FactoryElementsView {
    static let defaultFactory = FactoryElementsView()
    func createVC(_ element: ElementView, presenter: PresenterProtocol) -> UIViewController {
        switch element {
        case .filterView: return createFactory(FactoryFilterView(presenter: presenter as! FilterPresenterProtocol))
        case .recipesView: return createFactory(FactoryColletionRecipe(presenter: presenter as! RecipesPresenterProtocol))
        case .profileView: return createFactory(FactoryRecipeProfileController(presenter: presenter as! RecipeProfilePresenterProtocol))
        }
    }
    private func createFactory<T:FactoryProtocol>(_ factory: T) -> UIViewController {
        let vc = factory.createPreparedView()
        return vc
    }
}

private class FactoryFilterView: FactoryProtocol {
    private let presenter:  FilterPresenterProtocol

    
    init(presenter: FilterPresenterProtocol) {
        self.presenter = presenter
    }
    
    func createPreparedView() -> UIViewController {
        let filterController = FilterViewController()
        filterController.setPresenter(presenter)
        presenter.attachView(filterController)
        return filterController
    }
}

private class FactoryColletionRecipe: FactoryProtocol {
    private let presenter: RecipesPresenterProtocol
    
    init(presenter: RecipesPresenterProtocol) {
        self.presenter = presenter
    }

    func createPreparedView() -> UIViewController {
        let collectionRecipe = RecipesControllerView()
        collectionRecipe.setPresenter(presenter)
        presenter.attachView(collectionRecipe)
        return collectionRecipe
    }
}

private class FactoryRecipeProfileController: FactoryProtocol {
    private let presenter: RecipeProfilePresenterProtocol
    
    init(presenter: RecipeProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    func createPreparedView() -> UIViewController {
        let recipeProfileView = RecipeProfileViewController()
        recipeProfileView.setPreseter(presenter: presenter)
        presenter.attachView(recipeProfileView)
        return recipeProfileView
    }
}
