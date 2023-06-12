//
//  InformationView.swift
//  RecipeSearch
//
//  Created by user on 18.05.2023.
//
import UIKit

class InformationView: UIView {
    //MARK: - Outlets
    private let valuesView = ValuesView()

    lazy var buttonFavorite: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
      button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.layer.opacity = 0.5
        return button
    }()
    
    lazy var linkButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = UIColor.basic
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Instructions", for: .normal)
        return button
    }()
    
    //MARK: - View Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .basic
        layer.cornerRadius = 19
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.30
        layer.shadowOffset = CGSize(width: 2, height: 1)
        layer.shadowColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        addSubview(valuesView)
        addSubview(buttonFavorite)
        addSubview(linkButton)
        valuesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valuesView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            valuesView.leftAnchor.constraint(equalTo: leftAnchor),
            valuesView.rightAnchor.constraint(equalTo: rightAnchor),
            
            buttonFavorite.topAnchor.constraint(equalTo: valuesView.bottomAnchor, constant: 35),
            buttonFavorite.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            buttonFavorite.widthAnchor.constraint(equalToConstant: 40),
            buttonFavorite.heightAnchor.constraint(equalToConstant: 40),
            buttonFavorite.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            linkButton.topAnchor.constraint(equalTo: buttonFavorite.topAnchor),
            linkButton.leftAnchor.constraint(equalTo: buttonFavorite.rightAnchor, constant: 15),
            linkButton.bottomAnchor.constraint(equalTo:  bottomAnchor, constant: -10),
        ])
    }
}
