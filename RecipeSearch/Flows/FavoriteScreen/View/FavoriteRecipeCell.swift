//
//  FavoriteRecipeCell.swift
//  RecipeSearch
//
//  Created by user on 03.06.2023.
//

import UIKit
import CoreData

class FavoriteRecipeCell: UICollectionViewCell {
    //MARK: - Outlets
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
    
    //MARK: - Properties
    fileprivate var image: UIImage? {
        get {
            return self.imageRecipe.image
        } set {
            DispatchQueue.main.async {
                self.imageRecipe.image = newValue
            }
        }
    }
    //MARK: - View Functions
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleRecipe.text = nil
        self.imageRecipe.image = nil
    }
    
    private func setupSubviews() {
        contentView.addSubview(imageRecipe)
        contentView.addSubview(titleRecipe)
    }
}
//MARK: - Extension Functions
extension FavoriteRecipeCell {
    func setupCell(with recipeProfile: FavoriteRecipe) {
        titleRecipe.text = recipeProfile.title
        if let stringImage = recipeProfile.image,  let url = URL(string: stringImage) {
            imageRecipe.load(url:  url)
        }
    }
}

extension FavoriteRecipeCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
