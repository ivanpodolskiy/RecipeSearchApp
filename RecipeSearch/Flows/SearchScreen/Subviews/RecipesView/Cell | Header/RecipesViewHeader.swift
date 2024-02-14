//
//  RecipesViewHeader.swift
//  RecipeSearch
//
//  Created by user on 03.12.2023.
//

import UIKit

class RecipesViewHeader: UICollectionReusableView {
    private var countFoundedRecipes: Int = 0 {
        didSet {
            setText(use: countFoundedRecipes)
            recipesCountLabel.isHidden = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.recipesCountLabel.isHidden = true
    }
    
    private let recipesCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .selected
        return label
    }()
    
    private func setLayoutConstraint() {
        addSubview(recipesCountLabel)
        NSLayoutConstraint.activate([
            recipesCountLabel.topAnchor.constraint(equalTo: topAnchor),
            recipesCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            recipesCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setText(use count: Int) {
        switch count {
        case 1... : recipesCountLabel.text = "Found \(count) recipes"
        default :   recipesCountLabel.text  = "No recipes found for your request"
        }
    }
}
//MARK: - Extensions
extension RecipesViewHeader {
    static var indentifier: String { return String(describing: self)}
    func setRecipesCount(number: Int) {
        countFoundedRecipes = number
    }
}
