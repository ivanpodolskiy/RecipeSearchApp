//
//  SearchBarCell.swift
//  RecipeSearch
//
//  Created by user on 14.06.2023.
//

import UIKit

class FilterViewCell: UICollectionViewCell {
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Text", for: .normal)
        button.backgroundColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 19
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: leftAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.rightAnchor.constraint(equalTo: rightAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setButtonText(_ text: String)  {
        self.button.setTitle(text, for: .normal)
    }
}

extension FilterViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
