//
//  RecipeCell.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//
//0x7f7cf49113f0; frame = (0 1; 181.667 159
import UIKit

final class RecipeCell: UICollectionViewCell {
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var imageRecipe: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    private(set) lazy var viewForImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.backgroundColor = .brown
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    
    private(set) lazy var titleRecipe: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = UIColor.basic
        return title
    }()
    
    private(set) lazy var descriptionRecipe: UILabel = {
        let description = UILabel()
        description.textColor = UIColor(red: 123 / 255.0, green: 137 / 255.0, blue: 134 / 255.0, alpha: 1.0)
        description.textAlignment = .center
        description.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    private(set) lazy var buttonFavorite: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.layer.opacity = 0.5
        return button
    }()
    
    func setupCell(with recipeProfile: RecipeProfile) {
        titleRecipe.text = recipeProfile.title
        descriptionRecipe.text = recipeProfile.description
        imageRecipe.image = recipeProfile.image
        }
    
    private func setupLayouts() {
        viewForImage.addSubview(imageRecipe)
        imageRecipe.addSubview(buttonFavorite)
        contentView.addSubview(viewForImage)
        contentView.addSubview(titleRecipe)
        contentView.addSubview(descriptionRecipe)
      
        NSLayoutConstraint.activate([
            descriptionRecipe.bottomAnchor.constraint(equalTo: bottomAnchor),
            descriptionRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            descriptionRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            
            titleRecipe.bottomAnchor.constraint(equalTo: descriptionRecipe.topAnchor),
            titleRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            titleRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            
            imageRecipe.topAnchor.constraint(equalTo: topAnchor),
            imageRecipe.bottomAnchor.constraint(equalTo: titleRecipe.topAnchor, constant: -5),
            imageRecipe.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            imageRecipe.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            buttonFavorite.topAnchor.constraint(equalTo: topAnchor),
            buttonFavorite.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),

            buttonFavorite.widthAnchor.constraint(equalToConstant: 30),
            buttonFavorite.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension RecipeCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
