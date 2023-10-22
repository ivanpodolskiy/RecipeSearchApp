//
//  CategoryCollectionCell.swift
//  RecipeSearch
//
//  Created by user on 15.09.2023.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell  {
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 18)
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.blue // поменять цверт .ref
        return label
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
extension CategoryCollectionCell {
    func configure(value: CategoryValueProtocol, index: Int) {
        label.text = value.title
        label.textColor = value.getStatus() ? .selected  : .white 
    }
}
extension CategoryCollectionCell: ReusableView  {
    static var identifier: String {
        return String(describing: self)
    }
}
