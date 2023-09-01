//
//  RecipeCollectionView.swift
//  RecipeSearch
//
//  Created by user on 16.05.2023.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
    //MARK: - Properties
    private var recipeProfile: RecipeProfile
    private let favoriteRecipeService = FavoriteRecipeService()
    private lazy var slideInTransitioningDelegate = SelectionCategoryManager()
    
    public var completion: ((Bool?) -> Void)?
    
    //MARK: - Initialization
    init(recipe: RecipeProfile) {
        self.recipeProfile = recipe
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Ountlets
    private let detailRecipeView = DetailRecipeHeaderView()
    private let ingredientsView = IngredientsView()
    private let catehoriesView = CategoriesView()
    
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
    
    //MARK: - View Founctions
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        setInfoToViews()
    }
    
    private func setInfoToViews() {
        detailRecipeView.loadDataToViews(recipeProfile)
        let ingredients = recipeProfile.recipeInfromation.getInfromation(type: .ingredients)
        let healthList = recipeProfile.recipeInfromation.getInfromation(type: .healthList)
        ingredientsView.setInformation(ingredients, count: recipeProfile.countIngredients)
        detailRecipeView.informationView.valuesView.setData(countServings: 0, countDailyValue: 0, countCalories: recipeProfile.calories)
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
    
    //MARK: - Actions
    @objc func showWebScreen(sender: UIButton) {
        let name = recipeProfile.title
        let url = recipeProfile.url
        if let wbeController = WebViewController(name: name, url: url) {
            navigationController?.pushViewController(wbeController, animated: false)
        } else {
            self.present(alertController, animated: true)
        }
    }
    
    @objc func switchFavoriteStatus(sender: UILabel) {
        switch recipeProfile.isFavorite {
        case true:
            let recipeName = recipeProfile.title
            favoriteRecipeService.removeRecipe(recipeName: recipeName)
            sender.tintColor = .white
            recipeProfile.isFavorite = false
            completion?(false)
            
        case false:
            let titles = favoriteRecipeService.fetchAllTitleCategories()
            lazy var  selectionCategoryView = SelectionCategoryView(category: titles)
            selectionCategoryView.transitioningDelegate = slideInTransitioningDelegate
            selectionCategoryView.modalPresentationStyle = .custom
            selectionCategoryView.completion = { [weak self] selected in
                guard let self = self else { return  }
                switch selected {
                case .oldCategory(let name):
                    self.favoriteRecipeService.addFavoriteRecipe(recipeProfile, nameCategory: name, сategoryExists: true)
                    sender.tintColor = .yellow
                    recipeProfile.isFavorite = true
                    recipeProfile = recipeProfile
                    completion?(true)
                    
                case .newCategory(let name):
                    self.favoriteRecipeService.addFavoriteRecipe(recipeProfile, nameCategory: name, сategoryExists: false)
                    recipeProfile.isFavorite = true
                    sender.tintColor = .yellow
                    recipeProfile = recipeProfile
                    completion?(true)
                }
            }
            present(selectionCategoryView, animated: true)
        }
    }
}
