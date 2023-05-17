//
//  DetailRecipeView .swift
//  RecipeSearch
//
//  Created by user on 17.05.2023.
//

import Foundation
import UIKit

class DetailRecipeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.basic
        return label
    }()
    
    private(set) lazy var imageRecipe: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = UIColor(red: 243 / 255.0, green: 245 / 255.0, blue: 251 / 255.0, alpha: 1.0)
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()
    
    private(set) lazy var viewForImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    
    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        var ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    private(set) lazy var informationView: UIView = {
        let view = UIView()
        view.backgroundColor = .basic
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 19
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()

    func loadDataToViews(_ recipe: RecipeProfile) {
        self.titleLabel.text = recipe.title
        if let url = URL(string: recipe.image) {
            self.imageRecipe.load(url: url)
        }
        activityIndicator.stopAnimating()
       activityIndicator.isHidden = true
    }
        
    private func setupLayout() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        addSubview(titleLabel)
        addSubview(viewForImage)
        addSubview(informationView)
        viewForImage.addSubview(imageRecipe)
        imageRecipe.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),

            imageRecipe.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            imageRecipe.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            imageRecipe.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
           
            informationView.topAnchor.constraint(equalTo: imageRecipe.topAnchor, constant: 23),
            informationView.bottomAnchor.constraint(equalTo: imageRecipe.bottomAnchor, constant: -23),
            informationView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            informationView.leftAnchor.constraint(equalTo: imageRecipe.rightAnchor, constant: 10),

            imageRecipe.widthAnchor.constraint(equalToConstant: 180),
            imageRecipe.heightAnchor.constraint(equalToConstant: 180),
            
            activityIndicator.centerXAnchor.constraint(equalTo: imageRecipe.centerXAnchor, constant: 0.0),
            activityIndicator.centerYAnchor.constraint(equalTo: imageRecipe.centerYAnchor, constant: 0.0)
        ])
    }
}
