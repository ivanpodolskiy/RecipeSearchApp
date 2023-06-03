//
//  FavoriteRecipeCell.swift
//  RecipeSearch
//
//  Created by user on 03.06.2023.
//

import UIKit

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

    lazy var buttonFavorite: UIButton = {
       let button = UIButton(type: UIButton.ButtonType.custom)
       button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
       button.translatesAutoresizingMaskIntoConstraints = false
       button.tintColor = .white
        button.layer.opacity = 0.5
       return button
   }()
   
   private(set) lazy var imageRecipe: UIImageView = {
       let image = UIImageView()
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
           buttonFavorite.topAnchor.constraint(equalTo: topAnchor),
           buttonFavorite.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
           buttonFavorite.widthAnchor.constraint(equalToConstant: 30),
           buttonFavorite.heightAnchor.constraint(equalToConstant: 30),
       ])
   }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleRecipe.text = nil
        self.imageRecipe.image = nil
        self.buttonFavorite.tintColor = .white
    }
    
    private func setupSubviews() {
        contentView.addSubview(imageRecipe)
        imageRecipe.addSubview(buttonFavorite)
        contentView.addSubview(titleRecipe)
    }
}
//MARK: - Extension Functions
extension FavoriteRecipeCell {
    func setupCell(with recipeProfile: FavoriteRecipes) {
          titleRecipe.text = recipeProfile.title
        buttonFavorite.tintColor = .yellow
          DispatchQueue.global().async {
              guard let image =  recipeProfile.image, let imageURL = URL(string: image), let imageData = try? Data(contentsOf: imageURL)else  {
                  self.image = UIImage(named: "placeholder")
                  return
              }
              DispatchQueue.main.async {
                  self.image = UIImage(data: imageData)
              }
          }
      }
}

extension FavoriteRecipeCell: ReusableView {
   static var identifier: String {
       return String(describing: self)
   }
}
