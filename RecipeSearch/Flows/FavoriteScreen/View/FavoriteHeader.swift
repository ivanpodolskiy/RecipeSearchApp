//
//  FavoriteGeader.swift
//  RecipeSearch
//
//  Created by user on 04.06.2023.
//

import UIKit

class FavoriteHeader: UICollectionReusableView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(label)
        label.frame = bounds
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment  = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return  label
    }()
}

extension FavoriteHeader {
    static var identifier: String {
    return String(describing: self)
    }
    
    func setText(_ title: String) {
        label.text = title
    }
}
