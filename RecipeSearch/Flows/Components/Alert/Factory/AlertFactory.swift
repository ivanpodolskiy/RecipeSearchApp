//
//  AlertFactory.swift
//  RecipeSearch
//
//  Created by user on 21.12.2023.
//

import UIKit


enum AlertType {
    case notification(title: String, message: String)
    case solution(title: String, message: String, actionHandler: ((Any?) -> Void)?, cancelHandler: (() -> Void)?)
    case textField(title: String, message: String, actionHandler:  ((Any)  -> Void), cancelHandler: (() -> Void)?, textСheckingHandler: ((String) -> Bool)?, errorText: String?)
}

class AlertFactory {
    static let defaultFactory = AlertFactory()
    
    func getCustomAlert(type: AlertType ) -> CustomAlert  {
        switch type {
        case .notification(let title,let message):
            return NotificationAlert(title: title, message: message)
        case .solution(let title, let message, let actionHandler,  let cancelHandler):
            return SolutionAlert(title: title, message: message, actionHandler: actionHandler, cancelHandler: cancelHandler)
        case .textField(let title,let message,let actionHandler,let cancelHandler, let textСheckingHandler, let errorText):
            return TextFieldAlert(title: title, message: message, actionHandler: actionHandler, cancelHandler: cancelHandler, textСheckingHandler: textСheckingHandler, errorText: errorText)
        }
    }
}
