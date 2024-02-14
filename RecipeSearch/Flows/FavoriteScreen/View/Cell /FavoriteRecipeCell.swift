//
//  FavoriteRecipeCell.swift
//  RecipeSearch
//
//  Created by user on 03.06.2023.
//

import UIKit

class FavoriteRecipeCell: UICollectionViewCell {
    private(set) lazy var titleRecipe: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.numberOfLines = 2
        title.font = UIFont.boldSystemFont(ofSize: 15)
        title.textColor = UIColor.basic
        return title
    }()
    
    private(set) lazy var imageRecipe: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "placeholder")
        image.isUserInteractionEnabled = true
        image.backgroundColor = UIColor(red: 243 / 255.0, green: 245 / 255.0, blue: 251 / 255.0, alpha: 1.0)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 11
        image.clipsToBounds = true
        return image
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleRecipe.text = nil
        self.imageRecipe.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(imageRecipe)
        contentView.addSubview(titleRecipe)
        activateLayoutConstraint()
    }
    
    private func activateLayoutConstraint() {
        NSLayoutConstraint.activate([
            imageRecipe.topAnchor.constraint(equalTo: topAnchor),
            imageRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            imageRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            
            titleRecipe.topAnchor.constraint(equalTo: imageRecipe.bottomAnchor, constant: 5),
            titleRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            titleRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            titleRecipe.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleRecipe.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
//MARK: - Extension Functions
extension FavoriteRecipeCell {
    func setImage(_ image: UIImage) {
        self.imageRecipe.image = image
    }
    func setupCell(with recipeProfile: RecipeProfileProtocol) {
        titleRecipe.text = recipeProfile.title
    }
}

extension FavoriteRecipeCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
