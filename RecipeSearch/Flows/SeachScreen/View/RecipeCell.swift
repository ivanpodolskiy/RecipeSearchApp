//
//  RecipeCell.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//
import UIKit

 class RecipeCell: UICollectionViewCell {
    
     //MARK: - Outlets
    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        var ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
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
     
     lazy var buttonFavorite: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.layer.opacity = 0.5
        return button
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
        image.isUserInteractionEnabled = true
        image.backgroundColor = UIColor(red: 243 / 255.0, green: 245 / 255.0, blue: 251 / 255.0, alpha: 1.0)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8
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
                 self.activityIndicator.isHidden = true
                 self.activityIndicator.stopAnimating()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleRecipe.text = nil
        self.descriptionRecipe.text = nil
        self.imageRecipe.image = nil
        self.buttonFavorite.tintColor = .white
    }
    
    private func setupSubviews() {
        contentView.addSubview(imageRecipe)
        imageRecipe.addSubview(buttonFavorite)
        contentView.addSubview(viewForImage)
        contentView.addSubview(titleRecipe)
        contentView.addSubview(descriptionRecipe)
        imageRecipe.addSubview(activityIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            descriptionRecipe.bottomAnchor.constraint(equalTo: bottomAnchor),
            descriptionRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            descriptionRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            
            titleRecipe.bottomAnchor.constraint(equalTo: descriptionRecipe.topAnchor),
            titleRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            titleRecipe.rightAnchor.constraint(equalTo: rightAnchor),
                        
            imageRecipe.topAnchor.constraint(equalTo: topAnchor),
            imageRecipe.bottomAnchor.constraint(equalTo: titleRecipe.topAnchor, constant: -5),
            imageRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            imageRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            
            buttonFavorite.topAnchor.constraint(equalTo: topAnchor),
            buttonFavorite.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),

            buttonFavorite.widthAnchor.constraint(equalToConstant: 30),
            buttonFavorite.heightAnchor.constraint(equalToConstant: 30),

            activityIndicator.centerXAnchor.constraint(equalTo: imageRecipe.centerXAnchor, constant: 0.0),
            activityIndicator.centerYAnchor.constraint(equalTo: imageRecipe.centerYAnchor, constant: 0.0)
        ])
    }
}
//MARK: - Extension Functions
extension RecipeCell {
    func setColorToFavoriteButton(_ status: Bool) {
        DispatchQueue.main.async {
            switch status {
            case false:
                self.buttonFavorite.tintColor = .white

            case true:
                self.buttonFavorite.tintColor = .yellow
            }
        }
       
    }
    
    func setupCell(with recipeProfile: RecipeProfile, index: IndexPath) {
        if recipeProfile.isFavorite {
            setColorToFavoriteButton(recipeProfile.isFavorite)
        }
        buttonFavorite.tag = index.row
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        titleRecipe.text = recipeProfile.title
        descriptionRecipe.text = recipeProfile.description
        DispatchQueue.global().async {
            guard let imageURL = URL(string: recipeProfile.image), let imageData = try? Data(contentsOf: imageURL)else  {
                self.image = UIImage(named: "placeholder")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }
        }
    }
}

extension RecipeCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
