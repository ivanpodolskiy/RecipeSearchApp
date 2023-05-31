//
//  RecipeCollectionView.swift
//  RecipeSearch
//
//  Created by user on 16.05.2023.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
    //MARK: - Ountlets
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let alertController: UIAlertController = {
        let alert = UIAlertController(title: "Error", message: "Link is not available", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(actionAlert)
        return alert
    }()
    
    private let detailRecipeView = DetailRecipeHeaderView()
    private let ingredientsView = IngredientsView()
    private let catehoriesView = CatehoriesView()

    //MARK: - Properties
    private var recipeProfile: RecipeProfile?
    private let favoriteRecipeService = FavoriteRecipeService()
    public var completion: ((Bool?) -> Void)?
    
    //MARK: - Initialization
    init(recipe: RecipeProfile?) {
        self.recipeProfile = recipe
        super.init(nibName: nil, bundle: nil)
    }
    convenience init() {
        self.init(recipe: nil)
    }
    
    //MARK: - View Founctions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setInfoToViews()
    }
    
    override func viewDidLayoutSubviews() {
        ingredientsView.translatesAutoresizingMaskIntoConstraints = false
        catehoriesView.translatesAutoresizingMaskIntoConstraints = false
        detailRecipeView.translatesAutoresizingMaskIntoConstraints  = false
        view.addSubview(scrollView)
        view.addSubview(ingredientsView)
        view.addSubview(catehoriesView)
        scrollView.addSubview(detailRecipeView)
        scrollView.addSubview(ingredientsView)
        scrollView.addSubview(catehoriesView)
        
        detailRecipeView.informationView.buttonFavorite.addTarget(self, action: #selector(switchFavoriteStatus(sender: )), for: .touchUpInside)
        detailRecipeView.informationView.linkButton.addTarget(self, action: #selector(showWebScreen(sender: )), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            detailRecipeView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            detailRecipeView.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailRecipeView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            ingredientsView.topAnchor.constraint(equalTo: detailRecipeView.bottomAnchor, constant: 10),
            ingredientsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            ingredientsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -15),
                 
            catehoriesView.topAnchor.constraint(equalTo: ingredientsView.bottomAnchor, constant: 10),
            catehoriesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            catehoriesView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -30),
            catehoriesView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func showWebScreen(sender: UIButton) {
            if let recipe =  recipeProfile   {
                let name = recipe.title
                let url = recipe.url
                print (url)
                let wbeController = WebViewController(name: name, url: url)
                navigationController?.pushViewController(wbeController, animated: false)
            } else {
                showAlert()
            }
        }
    
    @objc func switchFavoriteStatus(sender: UILabel) {
        guard let selectedRecipe = recipeProfile else { return }
            switch selectedRecipe.isFavorite {
            case true:
                favoriteRecipeService.removeFavotireRecipe(name: selectedRecipe.title)
                sender.tintColor = .white
                recipeProfile?.isFavorite = false
                completion?(false)
            case false:
                sender.tintColor = .yellow
                favoriteRecipeService.addFavoriteRecipe(selectedRecipe)
                recipeProfile?.isFavorite = true
                completion?(true)
            }
    }
    
    //MARK: - Functions
    private func setInfoToViews() {
        if let recipe = recipeProfile {
            detailRecipeView.loadDataToViews(recipe)
            let ingredients = recipe.recipeInfromation.getInfromation(type: .ingredients)
            let healthList = recipe.recipeInfromation.getInfromation(type: .healthList)
            ingredientsView.setInformation(ingredients, count: recipe.countIngredients)
            catehoriesView.setText(healthList)
        }
    }
    
    private func showAlert() {
        self.present(alertController, animated: true)
    }
}
