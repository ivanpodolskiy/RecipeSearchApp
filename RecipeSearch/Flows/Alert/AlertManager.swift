//
//  AlertManager.swift
//  RecipeSearch
//
//  Created by user on 27.12.2023.
//

import UIKit

protocol AlertManagerProtocol {
    func setAlert(_ alert: CustomAlert)
    func showAlert()
    func dismisAlert()
}
class AlertManager: AlertManagerProtocol{
    private var alert: CustomAlert?
    private let windowService: WindowService
    
    init(windowService: WindowService = WindowService()) {
        self.windowService = windowService
    }
    
    func setAlert(_ alert: CustomAlert) {
        self.alert = alert
    }
    
    func showAlert() {
        guard let window = windowService.currentWindow, let alert = alert else { return }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDismissAlert))
        tapGesture.cancelsTouchesInView = true
        
        let backgroundView = UIView()
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.isUserInteractionEnabled = true
        backgroundView.tag = 10
        
        self.windowService.addViewToWindow(backgroundView)
        backgroundView.addSubview(alert)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: window.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            alert.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            alert.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            alert.widthAnchor.constraint(equalToConstant: 270),
        ])
    }
    
    func dismisAlert() {
        windowService.removeLastSubview()
    }
    
    @objc private func tapDismissAlert(_ sender: UITapGestureRecognizer)  {
        guard let subviews = windowService.getSubviews(), let backgroundView = subviews.last else { return}
        let touchLocation = sender.location(in: backgroundView)
        if !backgroundView.subviews.contains(where: { $0.frame.contains(touchLocation)}) {
            dismisAlert()
        }
    }
}
