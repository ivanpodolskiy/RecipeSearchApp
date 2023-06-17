//
//  SelectionCategoryManager.swift
//  RecipeSearch
//
//  Created by user on 06.06.2023.
//

import UIKit


class SelectionCategoryManager: NSObject {
  
    
}

extension SelectionCategoryManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

        let presentationController = SelectionFavoriteSectionController(presentedViewController: presented, presenting: presenting)
            return presentationController
            
    

    }
}
