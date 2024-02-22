//
//  RecipeCollectionView.swift
//  RecipeSearch
//
//  Created by user on 16.05.2023.
//

import UIKit

class RecipeProfileCompositeVC: UIViewController  {
    private var  detailRecipeVC: RecipeDetailViewController
    private let ingredientsView: IngredientsView
    private let categoriesView: CategoriesView
    
    init(recipeDetailVC: RecipeDetailViewController, ingredientsView: IngredientsView, categoriesView: CategoriesView) {
        self.detailRecipeVC = recipeDetailVC
        self.ingredientsView = ingredientsView
        self.categoriesView = categoriesView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviewAndSetupLayout()
        setupLayoutConstraint()
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private func addSubviewAndSetupLayout() {
        detailRecipeVC.view.translatesAutoresizingMaskIntoConstraints = false
        ingredientsView.translatesAutoresizingMaskIntoConstraints = false
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(detailRecipeVC)
        view.addSubview(scrollView)
        scrollView.addSubview(detailRecipeVC.view)
        scrollView.addSubview(ingredientsView)
        scrollView.addSubview(categoriesView)
    }
    
    private func setupLayoutConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            detailRecipeVC.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            detailRecipeVC.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            detailRecipeVC.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
            ingredientsView.topAnchor.constraint(equalTo: detailRecipeVC.view.bottomAnchor, constant: 10),
            ingredientsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            ingredientsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            
            categoriesView.topAnchor.constraint(equalTo: ingredientsView.bottomAnchor),
            categoriesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            categoriesView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -20),
            categoriesView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}
