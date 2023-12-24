//
//  AlertFactory.swift
//  RecipeSearch
//
//  Created by user on 21.12.2023.
//

import UIKit

enum AlertType {
    case notification(title: String, message: String, cancelHandler: (() -> Void)? )
    case solution(title: String, message: String, actionHandler: ((Any?) -> Void)?, cancelHandler: (() -> Void)?)
    case textField(title: String, message: String, actionHandler:  ((Any)  -> Void), cancelHandler: (() -> Void)?)
}

class AlertFactory {
    static let defaultFactory = AlertFactory()
    func getAlertController(type: AlertType) -> UIAlertController {
        switch type {
        case .notification(let title,let message, let  cancelHandler):
            return NotificationAlertUtility(title: title, message: message, cancelHandler: cancelHandler).getAlert()
        case .textField(let title, let message, let actionHandler, let cancelHandler):
            return TextFiledAlertUtility(title: title, message: message, placeholder: "", actionHandler: actionHandler, cancelHandler: cancelHandler).getAlert()
        case .solution(let title, let message, let actionHandler, let cancelHandler ):
            return SolutionAlertUtility(title: title, message: message, actionHandler: actionHandler, cancelHandler: cancelHandler).getAlert()
        }
    }
}
