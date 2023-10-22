//
//  CatehoriesView.swift
//  RecipeSearch
//
//  Created by user on 17.05.2023.
//

import UIKit

class CategoriesView: UIView {
    private(set) lazy var categoriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 123 / 255.0, green: 137 / 255.0, blue: 134 / 255.0, alpha: 1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 165/255.0, green: 166/255.0, blue: 246/255.0, alpha: 1)
        layer.cornerRadius = 20
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.cgColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        addSubview(categoriesLabel)
        NSLayoutConstraint.activate([
            categoriesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            categoriesLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            categoriesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            categoriesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        ])
    }
}
//MARK: - Extension
extension CategoriesView {
    func setText(_ text: [String]) {
        let string = text.toString(separator: " ")
        categoriesLabel.text = string
    }
}
