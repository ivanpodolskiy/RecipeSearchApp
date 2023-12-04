//
//  RecipesViewHeader.swift
//  RecipeSearch
//
//  Created by user on 03.12.2023.
//

import UIKit

class RecipesViewHeader: UICollectionReusableView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayoutConstraint()
    }
    private let recipesCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .gray
        return label
    }()
    
    private func setLayoutConstraint() {
        addSubview(recipesCountLabel)
        NSLayoutConstraint.activate([
            recipesCountLabel.topAnchor.constraint(equalTo: topAnchor),
            recipesCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            recipesCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.recipesCountLabel.isHidden = true
    }
}

extension RecipesViewHeader {
    static var indentifier: String { return String(describing: self)}
    func setRecipesCount(number: Int) {
        recipesCountLabel.isHidden = false

        recipesCountLabel.text = "Found \(number) recipes"
    }
}

