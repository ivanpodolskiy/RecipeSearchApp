//
//  ButtonsContainerView.swift
//  RecipeSearch
//
//  Created by user on 31.12.2023.
//

import UIKit

class ButtonsContainerView: UIView {
    func isActionButtonEnabled(_ enabled: Bool) {
        actionButton.isEnabled = enabled
    }
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.selected, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return button
    }()
    
    override func layoutSubviews() {
        addSubview(actionButton)
        addSubview(cancelButton)
        setupSubviewsConstraints()
    }
    
    private func setupSubviewsConstraints() {
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: topAnchor),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: centerXAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
