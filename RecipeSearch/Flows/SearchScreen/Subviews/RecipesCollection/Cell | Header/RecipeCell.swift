//
//  RecipeCell.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//
import UIKit


class RecipeCell: UICollectionViewCell  {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Outlets
    var favoriteButton: UIButton = {
       let button = UIButton(type: UIButton.ButtonType.custom)
       button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
       button.translatesAutoresizingMaskIntoConstraints = false
       button.tintColor = .white
       return button
   }()
    private(set) lazy var titleRecipe: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.layer.cornerRadius = 4
        title.clipsToBounds = true
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor.basic
        return title
    }()
    private(set) lazy var descriptionRecipe: UILabel = {
        let description = UILabel()
        description.layer.cornerRadius = 4
        description.clipsToBounds = true
        description.textColor = UIColor(red: 123 / 255.0, green: 137 / 255.0, blue: 134 / 255.0, alpha: 1.0)
        description.textAlignment = .center
        description.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
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
    private(set) lazy var imageRecipe: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.backgroundColor = UIColor(red: 243 / 255.0, green: 245 / 255.0, blue: 251 / 255.0, alpha: 1.0)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    //MARK: - View Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleRecipe.text = nil
        self.descriptionRecipe.text = nil
        self.imageRecipe.image = nil
        self.setColorToFavoriteButton(isFavorite: false)
    }
    
    private func setupSubviews() {
        contentView.addSubview(descriptionRecipe)
        contentView.addSubview(titleRecipe)
        contentView.addSubview(viewForImage)
        contentView.addSubview(imageRecipe)
        imageRecipe.addSubview(favoriteButton)
    }
    
     override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            imageRecipe.topAnchor.constraint(equalTo: topAnchor),
            imageRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            imageRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            imageRecipe.heightAnchor.constraint(equalTo: widthAnchor),
            
            titleRecipe.topAnchor.constraint(equalTo: imageRecipe.bottomAnchor, constant: 2),
            titleRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            titleRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            
            descriptionRecipe.topAnchor.constraint(equalTo: titleRecipe.bottomAnchor),
            descriptionRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            descriptionRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            descriptionRecipe.heightAnchor.constraint(equalToConstant: 20),
            descriptionRecipe.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            favoriteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -2),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
//MARK: - Extension Functions
extension RecipeCell {
    func setupCell(with recipeProfile: RecipeProfileProtocol, tag: Int) {
        DispatchQueue.main.async {
            self.titleRecipe.text = recipeProfile.title
            self.descriptionRecipe.text = recipeProfile.description
            self.favoriteButton.tag = tag
            if recipeProfile.isFavorite { self.setColorToFavoriteButton(isFavorite: true) }
        }
    }
    
    private func setColorToFavoriteButton(isFavorite status: Bool) {
            switch status {
            case false: favoriteButton.tintColor = .white
            case true: favoriteButton.tintColor = .yellow
        }
    }
    
    func setImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageRecipe.image = image
        }
    }
    
    func addTargetToButton(target: Any, action: Selector){
        favoriteButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
extension RecipeCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
