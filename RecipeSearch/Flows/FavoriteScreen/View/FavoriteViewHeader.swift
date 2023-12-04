//
//  FavoriteGeader.swift
//  RecipeSearch
//
//  Created by user on 04.06.2023.
//

import UIKit


class FavoriteViewHeader: UICollectionReusableView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayoutConstraint()
    }
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment  = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .gray
        return  label
    }()
    
    private let itemsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment  = .right
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .gray
        label.text = "0"
        return label
    }()
    
    private func setLayoutConstraint() {
        addSubview(titleLabel)
        addSubview(itemsCountLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.rightAnchor.constraint(equalTo: itemsCountLabel.leftAnchor),
            itemsCountLabel.rightAnchor.constraint(equalTo: rightAnchor),
            itemsCountLabel.topAnchor.constraint(equalTo: topAnchor),
            itemsCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
extension FavoriteViewHeader {
    static var identifier: String { return String(describing: self) }
    func setSectionDesctiption(title: String, countItems: Int) {
        titleLabel.text = title
        itemsCountLabel.text = String(countItems)
    }
}
