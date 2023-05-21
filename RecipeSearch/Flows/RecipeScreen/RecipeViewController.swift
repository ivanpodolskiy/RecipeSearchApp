//
//  RecipeCollectionView.swift
//  RecipeSearch
//
//  Created by user on 16.05.2023.
//

import Foundation
import UIKit

class RecipeViewController: UIViewController {
   
    private var recipeProfile: RecipeProfile?
    private let detailRecipeView = DetailRecipeHeaderView()
    private let ingredientsView = IngredientsView()
    private let catehoriesView = CatehoriesView()
    
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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    convenience init() {
        self.init(recipe: nil)
    }
    
    init(recipe: RecipeProfile?) {
        self.recipeProfile = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  

    private func setInfoToViews() {
        if let recipe = recipeProfile {
            detailRecipeView.loadDataToViews(recipe)
            let ingredients = recipe.recipeInfromation.getInfromation(type: .ingredients)
            let healthList = recipe.recipeInfromation.getInfromation(type: .healthList)

            ingredientsView.setInformation(ingredients, count: recipe.countIngredients)
            catehoriesView.setInformation(healthList)
        }
    }
}
