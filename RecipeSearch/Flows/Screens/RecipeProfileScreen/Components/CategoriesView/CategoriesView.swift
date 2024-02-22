//
//  CategoriesView.swift
//  RecipeSearch
//
//  Created by user on 17.05.2023.
//

import UIKit

class CategoriesView: UIView {
    private let titleText: String = "Categories: "
    private let textColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 122 / 255, alpha: 1.0)
    private let categoriesBackgroundColor = UIColor(red: 208 / 255, green: 233 / 255, blue: 220 / 255, alpha: 1.0)
    
    init(categoriesList: [String]) {
        super.init(frame: .zero)
        self.setText(categoriesList)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .basic
        label.textAlignment = .left
        label.text = titleText
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    private lazy var categoriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = textColor
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = categoriesBackgroundColor
        view.layer.cornerRadius = 12
        
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowColor = UIColor.black.cgColor
        
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(categoriesLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            categoriesLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            categoriesLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            categoriesLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            categoriesLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
        ])
        
    }
}
//MARK: - Extension
extension CategoriesView {
    private func setText(_ text: [String]) {
        let string = text.toString(separator: " \u{2022} ")
        categoriesLabel.text = string
    }
}
