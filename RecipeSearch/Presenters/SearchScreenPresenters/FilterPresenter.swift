//
//  FilterPresenter.swift
//  RecipeSearch
//
//  Created by user on 09.10.2023.
//

import Foundation
import UIKit

//MARK: Filter Protocols
protocol FilterPresenterProtocol:  PresenterProtocol {
    func selectCategoryValue(index: Int)
    func displaySecletedCategory(_ type: CategoryType?)
}
//MARK: Delegate
protocol FilterViewDelegate: AnyObject, UIViewController {
    func updateCategoryView(categoryType: CategoryType)
    func updateCollectionView(categoryValues: [CategoryValueProtocol])
}
//MARK: - FilterPresenter
class  FilterPresenter: FilterPresenterProtocol  {
    var categoryManager:CategoryManagerProtocol!
    weak var  filterControllerDelegate: FilterViewDelegate?

    init(categoryManager: CategoryManagerProtocol) {
        self.categoryManager = categoryManager
    }
    func attachView(_ view: UIViewController) { filterControllerDelegate = view as? FilterViewDelegate
    }
    
    func selectCategoryValue(index: Int) {
        let updatedhData =  categoryManager.changeStatus(index)
        filterControllerDelegate?.updateCollectionView(categoryValues: updatedhData)
    }
    func displaySecletedCategory(_ type: CategoryType?) {
        categoryManager.getCategoryData(categoryType: type) { [weak self] values, type  in
            guard let self = self else { return}
            self.filterControllerDelegate?.updateCategoryView(categoryType: type)
            self.filterControllerDelegate?.updateCollectionView(categoryValues: values)
        }
    }
}

