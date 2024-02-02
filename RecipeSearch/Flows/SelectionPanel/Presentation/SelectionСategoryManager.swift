//
//  SelectionSectionManagerView.swift
//  RecipeSearch
//
//  Created by user on 06.06.2023.
//

import UIKit


class PanelTransition: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PanelPresentationController(presentedViewController: presented, presenting: presenting ?? source)
    }
}
