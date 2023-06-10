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
    private lazy var slideInTransitioningDelegate = SelectionCategoryManager()
    
    //MARK: - Initialization
    init(recipe: RecipeProfile) {
        self.recipeProfile = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - View Founctions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setInfoToViews()
    }
    
    private func setInfoToViews() {
        guard let recipe = recipeProfile else { return }
        detailRecipeView.loadDataToViews(recipe)
        let ingredients = recipe.recipeInfromation.getInfromation(type: .ingredients)
        let healthList = recipe.recipeInfromation.getInfromation(type: .healthList)
        ingredientsView.setInformation(ingredients, count: recipe.countIngredients)
        catehoriesView.setText(healthList)
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
        
        detailRecipeView.informationView.buttonFavorite.addTarget(self, action: #selector(presentViewControllerWithCustomPresentation(sender: )), for: .touchUpInside)
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
    
    //MARK: - Actions
    @objc func showWebScreen(sender: UIButton) {
        if let recipe =  recipeProfile   {
            let name = recipe.title
            let url = recipe.url
            let wbeController = WebViewController(name: name, url: url)
            navigationController?.pushViewController(wbeController, animated: false)
        } else {
            self.present(alertController, animated: true)
        }
    }
    
    @objc func switchFavoriteStatus(sender: UILabel) {
        guard var selectedRecipe = recipeProfile else { return }
        
        switch selectedRecipe.isFavorite {
        case true:
            selectedRecipe.isFavorite = false
            favoriteRecipeService.removeRecipe(recipeName: selectedRecipe.title)
            sender.tintColor = .white
            recipeProfile = selectedRecipe
            
        case false:
            let titles = favoriteRecipeService.fetchAllTitleCategories()
            lazy var  selectionCategoryView = SelectionCategoryView(category: titles)
            selectionCategoryView.transitioningDelegate = slideInTransitioningDelegate
            selectionCategoryView.modalPresentationStyle = .custom
            
            selectionCategoryView.completion = { [weak self] selected in
                guard let self = self else { return  }
                switch selected {
                case .oldCategory(let name):
                    self.favoriteRecipeService.addFavoriteRecipe(selectedRecipe, nameCategory: name, сategoryExists: true)
                    sender.tintColor = .yellow
                    selectedRecipe.isFavorite = true
                    recipeProfile = selectedRecipe
                    
                case .newCategory(let name):
                    self.favoriteRecipeService.addFavoriteRecipe(selectedRecipe, nameCategory: name, сategoryExists: false)
                    selectedRecipe.isFavorite = true
                    sender.tintColor = .yellow
                    recipeProfile = selectedRecipe
                }
            }
            present(selectionCategoryView, animated: true)
        }
    }
    
    @objc func presentViewControllerWithCustomPresentation(sender: UIButton) {
        lazy var selectionCategoryView = SelectionCategoryView(category: favoriteRecipeService.fetchAllTitleCategories())
        selectionCategoryView.transitioningDelegate = slideInTransitioningDelegate
        selectionCategoryView.modalPresentationStyle = .custom
        present(selectionCategoryView, animated: true)
    }
}
