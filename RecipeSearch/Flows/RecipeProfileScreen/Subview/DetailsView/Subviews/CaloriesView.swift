//
//  CaloriesView.swift
//  RecipeSearch
//
//  Created by user on 07.02.2024.
//

import UIKit

class CaloriesView: UIView {
    private let caloriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    private let kcalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "kcal"
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        activateLayoutActivate()
    }
    
    private func addSubviews(){
        addSubview(caloriesLabel)
        addSubview(kcalLabel)
    }
    
    private func activateLayoutActivate(){
        NSLayoutConstraint.activate([
            caloriesLabel.leftAnchor.constraint(equalTo: leftAnchor),
            caloriesLabel.lastBaselineAnchor.constraint(equalTo: bottomAnchor),
            kcalLabel.leftAnchor.constraint(equalTo: caloriesLabel.rightAnchor),
            kcalLabel.lastBaselineAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension CaloriesView {
    func setText(with calories: Int) {
        caloriesLabel.text = String(calories)
    }
    
    func setTextColor(color: UIColor) {
        caloriesLabel.textColor = color
        kcalLabel.textColor = color
    }
}
