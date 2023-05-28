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
    
    private let detailRecipeView = DetailRecipeHeaderView()
    private let ingredientsView = IngredientsView()
    private let catehoriesView = CatehoriesView()

    //MARK: - Properties
    private var recipeProfile: RecipeProfile?
    private let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        view.addSubview(scrollView)
        scrollView.addSubview(detailRecipeView)
        scrollView.addSubview(ingredientsView)
        scrollView.addSubview(catehoriesView)
        detailRecipeView.informationView.buttonFavorite.addTarget(self, action: #selector(switchFavoriteStatus(sender: )), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            detailRecipeView.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailRecipeView.rightAnchor.constraint(equalTo: view.rightAnchor),
            detailRecipeView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            ingredientsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            ingredientsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -15),
            ingredientsView.topAnchor.constraint(equalTo: detailRecipeView.bottomAnchor, constant: 10),
            
            catehoriesView.topAnchor.constraint(equalTo: ingredientsView.bottomAnchor, constant: 20),
            catehoriesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            catehoriesView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -30),
            catehoriesView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func switchFavoriteStatus(sender: UILabel) {
        guard let selectedRecipe = recipeProfile else { return }
        do {
            let favoriteRecipes = try contex.fetch(FavoriteRecipes.fetchRequest())
            switch selectedRecipe.isFavorite {
            case true:
                try favoriteRecipes.forEach { fRecipe in
                   if fRecipe.title == selectedRecipe.title {
                       sender.tintColor = .white
                       contex.delete(fRecipe)
                       try contex.save()
                   }
                }
                recipeProfile?.isFavorite = false
                completion?(false)
            case false:
                sender.tintColor = .yellow
                let favoriteRecipe = FavoriteRecipes(context: self.contex)
                favoriteRecipe.title = selectedRecipe.title
                recipeProfile?.isFavorite = true
                try contex.save()
                completion?(true)
            }
        } catch {
            
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
}
