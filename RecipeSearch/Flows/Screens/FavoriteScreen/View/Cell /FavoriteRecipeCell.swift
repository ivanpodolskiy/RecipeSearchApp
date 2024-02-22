//
//  FavoriteRecipeCell.swift
//  RecipeSearch
//
//  Created by user on 03.06.2023.
//

import UIKit

class FavoriteRecipeCell: UICollectionViewCell {
    private(set) lazy var favoriteButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName:"star.fill"), for: .normal)
        button.tintColor = .yellow
        return button
    }()
    private(set) lazy var titleRecipe: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.numberOfLines = 0
        title.font = UIFont.boldSystemFont(ofSize: 17)
        title.textColor = UIColor.basic
        return title
    }()
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "placeholder")
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = UIColor(red: 243 / 255.0, green: 245 / 255.0, blue: 251 / 255.0, alpha: 1.0)
        imageView.layer.cornerRadius = 11
        imageView.clipsToBounds = true
        return imageView
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleRecipe.text = nil
        self.imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(imageView)
        contentView.addSubview(titleRecipe)
        imageView.addSubview(favoriteButton)
        activateLayoutConstraint()
    }
    
    private func activateLayoutConstraint() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor),
            
            titleRecipe.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titleRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            titleRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            titleRecipe.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            favoriteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -2),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
//MARK: - Extension Functions
extension FavoriteRecipeCell {
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    func setupCell(with recipeProfile: RecipeProfileProtocol) {
        titleRecipe.text = recipeProfile.title
    }
    
    func addTargetToButton(target: Any, action: Selector){
        favoriteButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

extension FavoriteRecipeCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
