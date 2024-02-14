//
//  ViewControllerFactory.swift
//  RecipeSearch
//
//  Created by user on 22.09.2023.
//

import UIKit

protocol VCFactoryProtocol { func createPreparedVC() -> UIViewController }

enum ControllerType {
    case filterVC
    case recipesVC
    case detailsVC
}

class VCFactory {
    static let defaultFactory = VCFactory()
    
    func createVC(_ element: ControllerType, presenter: PresenterProtocol) -> UIViewController {
        switch element {
        case .filterVC: return createFactory(FactoryFilterVC(presenter: presenter as! FilterPresenterProtocol))
        case .recipesVC: return createFactory(FactoryColletionRecipe(presenter: presenter as! RecipesPresenterProtocol))
        case .detailsVC: return createFactory(FactoryRecipeDetailsVC(presenter: presenter as! DetailsPresenterProtocol))
        }
    }
    
    private func createFactory<T:VCFactoryProtocol>(_ factory: T) -> UIViewController {
        let vc = factory.createPreparedVC()
        return vc
    }
}

private class FactoryFilterVC: VCFactoryProtocol {
    private let presenter:  FilterPresenterProtocol
    init(presenter: FilterPresenterProtocol) {
        self.presenter = presenter
    }
    
    func createPreparedVC() -> UIViewController {
        let filterController = FilterViewController()
        filterController.setPresenter(presenter)
        presenter.attachView(filterController)
        return filterController
    }
}

private class FactoryColletionRecipe: VCFactoryProtocol {
    private let presenter: RecipesPresenterProtocol
    init(presenter: RecipesPresenterProtocol) {
        self.presenter = presenter
    }

    func createPreparedVC() -> UIViewController {
        let collectionRecipe = RecipesViewController()
        collectionRecipe.setPresenter(presenter)
        presenter.attachView(collectionRecipe)
        return collectionRecipe
    }
}

private class FactoryRecipeDetailsVC: VCFactoryProtocol {
   private let presenter: DetailsPresenterProtocol
    init(presenter: DetailsPresenterProtocol) {
        self.presenter = presenter
    }
    
    func createPreparedVC() -> UIViewController {
        let detailsVC = DetailsCompositeView()
        detailsVC.setPreseter(presenter)
        presenter.attachView(detailsVC)
        return detailsVC
    }
}
