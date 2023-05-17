//
//  CatehoriesView.swift
//  RecipeSearch
//
//  Created by user on 17.05.2023.
//

import UIKit

class CatehoriesView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var catehoriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 123 / 255.0, green: 137 / 255.0, blue: 134 / 255.0, alpha: 1.0)
        label.textAlignment = .left
        label.text = "Low-Fat, Low-Sodium, Vegan, Vegetarian, Paleo, Dairy-Free, Gluten-Free, Egg-Free, Peanut-Free, Tree-Nut-Free, Soy-Free, Fish-Free, Shellfish-Free" 
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 165/255.0, green: 166/255.0, blue: 246/255.0, alpha: 1)
        layer.cornerRadius = 20
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.cgColor
    }
    
    private func setupLayout() {
        addSubview(catehoriesLabel)
        NSLayoutConstraint.activate([
            catehoriesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            catehoriesLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            catehoriesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            catehoriesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        ])
    }
}
