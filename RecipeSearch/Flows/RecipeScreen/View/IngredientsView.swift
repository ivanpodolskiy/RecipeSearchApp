//
//  IngredientsView.swift
//  RecipeSearch
//
//  Created by user on 17.05.2023.
//

import Foundation
import UIKit

class IngredientsView: UIView {
    //MARK: - Ountlets
    private(set) lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .basic
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor(red: 123 / 255.0, green: 137 / 255.0, blue: 134 / 255.0, alpha: 1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    //MARK: - View Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 252/255.0, green: 221/255.0, blue: 236/255.0, alpha: 1)
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
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            title.rightAnchor.constraint(equalTo: rightAnchor,constant: -15),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            title.heightAnchor.constraint(equalToConstant: 30),
            
            descriptionLabel.topAnchor.constraint(equalTo: title.bottomAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
//MARK: _ Functions
extension IngredientsView {
    func setInformation(_ text: String, count: Int) {
        self.title.text = "\(count) Ingredients"
        self.descriptionLabel.text = text
    }
}
