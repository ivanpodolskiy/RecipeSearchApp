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
    private let detailRecipeView = DetailRecipeView()
    private let ingredientsView = IngredientsView()
    private let catehoriesView = CatehoriesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print ("You see Recipe Screen")
        setupLayout()
    }
    
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

    private func setupLayout() {
        view.addSubview(detailRecipeView)
        view.addSubview(ingredientsView)
        view.addSubview(catehoriesView)
        if let recipe = recipeProfile {
            detailRecipeView.loadDataToViews(recipe)
        }
        NSLayoutConstraint.activate([
            detailRecipeView.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailRecipeView.rightAnchor.constraint(equalTo: view.rightAnchor),
            detailRecipeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailRecipeView.heightAnchor.constraint(equalToConstant: 225),
            
            ingredientsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            ingredientsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -15),
            ingredientsView.topAnchor.constraint(equalTo: detailRecipeView.bottomAnchor, constant: 10),
            ingredientsView.heightAnchor.constraint(equalToConstant: 150),
            
            catehoriesView.topAnchor.constraint(equalTo: ingredientsView.bottomAnchor, constant: 20),
            catehoriesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            catehoriesView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -30),
            catehoriesView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}
