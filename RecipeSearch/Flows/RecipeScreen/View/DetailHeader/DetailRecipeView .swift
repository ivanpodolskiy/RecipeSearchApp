//
//  DetailRecipeHeaderView .swift
//  RecipeSearch
//
//  Created by user on 17.05.2023.
//

import Foundation
import UIKit

class DetailRecipeHeaderView: UIView {
    //MARK: - Ountlets
    private(set) lazy var informationView  = InformationView()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
        view.layer.shadowOpacity = 0.30
        view.layer.shadowOffset = CGSize(width: 2, height: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    
    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        var ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.startAnimating()
        ai.isHidden = false
        return ai
    }()
    //MARK: - View Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
      addSubview(titleLabel)
      addSubview(viewForImage)
      addSubview(informationView)
      viewForImage.addSubview(imageRecipe)
      imageRecipe.addSubview(activityIndicator)
      
    informationView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
          titleLabel.topAnchor.constraint(equalTo: topAnchor),
          titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),

          imageRecipe.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
          imageRecipe.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
          imageRecipe.widthAnchor.constraint(equalToConstant: 180),
          imageRecipe.heightAnchor.constraint(equalToConstant: 185),
          imageRecipe.bottomAnchor.constraint(equalTo: bottomAnchor),
       
          informationView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
          informationView.leftAnchor.constraint(equalTo: imageRecipe.rightAnchor, constant: 10),
          informationView.centerYAnchor.constraint(equalTo: imageRecipe.centerYAnchor),
        
          activityIndicator.centerXAnchor.constraint(equalTo: imageRecipe.centerXAnchor, constant: 0.0),
          activityIndicator.centerYAnchor.constraint(equalTo: imageRecipe.centerYAnchor, constant: 0.0)
      ])
    }
   
    //MARK: - Functions
    func loadDataToViews(_ recipe: RecipeProfile) {
        self.titleLabel.text = recipe.title
        if let url = URL(string: recipe.image) {
            self.imageRecipe.load(url: url)
        }
        
        if recipe.isFavorite {
            informationView.buttonFavorite.tintColor = .yellow
        }
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
