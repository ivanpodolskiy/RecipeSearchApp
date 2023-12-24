//
//  AlertUtility.swift
//  RecipeSearch
//
//  Created by user on 26.10.2023.
//

import UIKit

//MARK: - AlertProtocols
protocol AlertUtilityProtocol {
    var title: String { get  }
    var message: String { get }
    func getAlert() -> UIAlertController
    init(title: String, message: String)
}
extension AlertUtilityProtocol {
    func createAlertController() -> UIAlertController {
        UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
}
//MARK: - ActionProtocols
protocol ActionHandlerProtocol { var actionHandler: ((Any)  -> Void)?{get set } }
protocol CancelHandlerProtocol { var cancelHandler: (() -> Void)? {get set} }
protocol HandlersAlertProtocol: ActionHandlerProtocol, CancelHandlerProtocol { }
//MARK: -- AlertUtility
class AlertUtility: AlertUtilityProtocol{
    var title: String
    var message: String

    required init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    func getAlert() -> UIAlertController {
        let alertController = createAlertController()
        return alertController
    }
}
//MARK: - NotificationAlertUtility
class NotificationAlertUtility: AlertUtility, CancelHandlerProtocol {
    var cancelHandler: (() -> Void)?
    
    init(title: String, message: String, cancelHandler: ( () -> Void)? = nil) {
        self.cancelHandler = cancelHandler
        super.init(title: title, message: message)
    }
    required init(title: String, message: String) {
        super.init(title: title, message: message)    }
    
    override func getAlert() -> UIAlertController {
        let alertController = createAlertController()
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            guard let cancelHandler = self.cancelHandler else { return }
            cancelHandler()
        }
        alertController.addAction(cancel)
        return alertController
    }
}
//MARK: - SolutionAlertUtility
class SolutionAlertUtility: AlertUtility, HandlersAlertProtocol{
    internal var actionHandler: ((Any) -> Void)?
    internal var cancelHandler: (() -> Void)?
    
    init(title: String, message: String, actionHandler: ((Any) -> Void)?, cancelHandler: (() -> Void)?) {
        super.init(title: title, message: message)
        self.actionHandler = actionHandler
        self.cancelHandler = cancelHandler
    }
    required init(title: String, message: String) {
        super.init(title: title, message: message)
    }
    override func getAlert() -> UIAlertController {
        let alertController = createAlertController()
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            guard let cancelHandler = self.cancelHandler else { return }
            cancelHandler()
        }
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            guard let actionHandler = self.actionHandler else {return }
            actionHandler(())
        }
        alertController.addAction(action)
        alertController.addAction(cancel)
        return alertController
    }
}

//MARK: - TextFiledAlertUtility
class TextFiledAlertUtility: AlertUtility,HandlersAlertProtocol, CancelHandlerProtocol {
    internal var actionHandler: ((Any) -> Void)?
    internal  var cancelHandler: (() -> Void)?
    
    private var alertController: UIAlertController!
    private var placeholder: String
   
    init(title: String, message: String, placeholder: String, actionHandler:  ((Any) -> Void)?, cancelHandler:  (() -> Void)?) {
        self.placeholder = placeholder
        self.actionHandler = actionHandler
        self.cancelHandler = cancelHandler
        super.init(title: title, message: message)
    }
    required init(title: String, message: String) {
        self.placeholder = ""
        super.init(title: title, message: message)
    }
    private func createAlertController() -> UIAlertController {
        let  alertController = super.createAlertController()
         alertController.addTextField { [weak self] textField in
            guard let self = self else { return }
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = placeholder
            textField.clearButtonMode = .whileEditing
            textField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        }
        return alertController
    }
    override func getAlert() -> UIAlertController {
        alertController = createAlertController()
        let action = UIAlertAction(title: "Ok", style: .default) { [self] _ in
            if let textField = alertController.textFields?.first,
               let text = textField.text {
                actionHandler?(text)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [self] _ in
            guard let cancelHandler = cancelHandler else { return }
            cancelHandler()
        }
        action.isEnabled = false
        alertController.addAction(action)
        alertController.addAction(cancel)
        return alertController
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
         guard let text = textField.text else { return }
         if let action = alertController?.actions.first {
             action.isEnabled = !text.isEmpty
         }
     }
}
