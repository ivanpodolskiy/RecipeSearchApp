//
//  HeaderView.swift
//  RecipeSearch
//
//  Created by user on 21.05.2023.
//

import UIKit

class HeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private(set) lazy var label: UILabel = {
      let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .brown
        label.text = "Header View"
        return label
    }()
}

extension HeaderView: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
    
    
}
