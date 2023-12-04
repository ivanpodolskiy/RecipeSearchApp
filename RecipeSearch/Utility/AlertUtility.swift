//
//  AlertUtility.swift
//  RecipeSearch
//
//  Created by user on 26.10.2023.
//

import UIKit
class AlertUtility {
        func textInputAlert(title: String, message: String, placeholder: String, target: UIViewController, handleTextFieldTextChanged: Selector, completion: @escaping (String?) -> Void, cancelCompletion: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { [weak target] textField in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = placeholder
            textField.clearButtonMode = .whileEditing
            textField.addTarget(target, action: handleTextFieldTextChanged, for: .editingChanged)
        }
        let action = UIAlertAction(title: "Create", style: .default) {  _ in
            if let textField = alertController.textFields?.first,
               let text = textField.text { completion(text) }
        }
        action.isEnabled = false
        alertController.addAction(action)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in cancelCompletion?() }
        alertController.addAction(cancel)
        return alertController
    }
    
    func notificationAlert(title: String, message: String, target: UIViewController, cancelCompletion: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelCompletion?()
        }
        alertController.addAction(cancel)
        return alertController
    }
}
