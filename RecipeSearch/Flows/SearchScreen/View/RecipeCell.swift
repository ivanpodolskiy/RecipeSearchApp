//
//  RecipeCell.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//
import UIKit


class RecipeCell: UICollectionViewCell  {
    //MARK: - Outlets

    private(set) lazy var titleRecipe: UILabel = {
        let title = UILabel()
        title.text = ""
        title.layer.cornerRadius = 4
        title.backgroundColor = UIColor(red: 243 / 255.0, green: 245 / 255.0, blue: 251 / 255.0, alpha: 1.0)
        title.clipsToBounds = true
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = UIColor.basic
        return title
    }()
    
    private(set) lazy var descriptionRecipe: UILabel = {
        let description = UILabel()
        description.text = ""
        description.layer.cornerRadius = 4
        description.backgroundColor = UIColor(red: 243 / 255.0, green: 245 / 255.0, blue: 251 / 255.0, alpha: 1.0)
        description.clipsToBounds = true
        

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
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.backgroundColor = UIColor(red: 243 / 255.0, green: 245 / 255.0, blue: 251 / 255.0, alpha: 1.0)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
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
        for uiItem in [descriptionRecipe,titleRecipe] {
            uiItem.backgroundColor = UIColor(red: 243 / 255.0, green: 245 / 255.0, blue: 251 / 255.0, alpha: 1.0)
        }
//        self.buttonFavorite.tintColor = .white
    }
    
    private func setupSubviews() {
        contentView.addSubview(descriptionRecipe)
        contentView.addSubview(titleRecipe)
        contentView.addSubview(viewForImage)
        contentView.addSubview(imageRecipe)
        imageRecipe.addSubview(buttonFavorite)
    }
    
     override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            imageRecipe.topAnchor.constraint(equalTo: self.topAnchor),
            imageRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            imageRecipe.heightAnchor.constraint(equalToConstant: 198),
            imageRecipe.widthAnchor.constraint(equalToConstant: 198),
            
            titleRecipe.topAnchor.constraint(equalTo: imageRecipe.bottomAnchor, constant: 5),
            titleRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            titleRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            titleRecipe.heightAnchor.constraint(equalToConstant: 25),
            
            descriptionRecipe.topAnchor.constraint(equalTo: titleRecipe.bottomAnchor, constant: 5),
            descriptionRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            descriptionRecipe.rightAnchor.constraint(equalTo: rightAnchor),
            descriptionRecipe.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            buttonFavorite.topAnchor.constraint(equalTo: topAnchor),
            buttonFavorite.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            buttonFavorite.widthAnchor.constraint(equalToConstant: 30),
            buttonFavorite.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
}
//MARK: - Extension Functions
extension RecipeCell {
    func setupPlaceholder() {
        self.imageRecipe.image = nil
        for uiItem in [descriptionRecipe,titleRecipe] {
            uiItem.backgroundColor = UIColor(red: 243 / 255.0, green: 245 / 255.0, blue: 251 / 255.0, alpha: 1.0)
        }
    }
    func setupCell(with recipeProfile: RecipeProfile, index: IndexPath) {
        if recipeProfile.isFavorite { setColorToFavoriteButton(recipeProfile.isFavorite)}
        buttonFavorite.tag = index.row
        
        let url = URL(string: recipeProfile.image)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let data = data, error == nil,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                titleRecipe.text = recipeProfile.title
                descriptionRecipe.text = recipeProfile.description
                imageRecipe.image = image
                
                for uiItem in [descriptionRecipe,titleRecipe] {
                    uiItem.backgroundColor = .white
                }
            }
            
        }.resume()
    }
    
     func setColorToFavoriteButton(_ status: Bool) {
             switch status {
             case false: buttonFavorite.tintColor = .white
             case true: buttonFavorite.tintColor = .yellow
         }
     }
}

extension RecipeCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
