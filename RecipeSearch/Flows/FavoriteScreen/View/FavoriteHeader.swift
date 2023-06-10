//
//  FavoriteGeader.swift
//  RecipeSearch
//
//  Created by user on 04.06.2023.
//

import UIKit

class FavoriteHeader: UICollectionReusableView {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment  = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return  label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(label)
        label.frame = bounds
    }
}

extension FavoriteHeader {
    static var identifier: String {
        return String(describing: self)
    }
    
    func setText(_ title: String) {
        label.text = title
    }
}
