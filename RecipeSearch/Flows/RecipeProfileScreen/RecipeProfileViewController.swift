//
//  RecipeCollectionView.swift
//  RecipeSearch
//
//  Created by user on 16.05.2023.
//

import UIKit

class RecipeProfileViewController: UIViewController  {
    private var presenter: RecipeProfilePresenterProtocol
    
    private var  detailRecipeView: DetailsCompositeView
    private let ingredientsView = IngredientsView()
    private let categoriesView = CategoriesView()
    
    init(presenter: RecipeProfilePresenterProtocol!, detailRecipeView: DetailsCompositeView) {
        self.presenter = presenter
        self.detailRecipeView = detailRecipeView
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        presenter.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviewAndSetupLayout()
        setupLayoutConstraint()
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private func addSubviewAndSetupLayout() {
        detailRecipeView.view.translatesAutoresizingMaskIntoConstraints = false
        ingredientsView.translatesAutoresizingMaskIntoConstraints = false
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(detailRecipeView)
        view.addSubview(scrollView)
        scrollView.addSubview(detailRecipeView.view)
        scrollView.addSubview(ingredientsView)
        scrollView.addSubview(categoriesView)
    }
    
    private func setupLayoutConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            detailRecipeView.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            detailRecipeView.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            detailRecipeView.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
            ingredientsView.topAnchor.constraint(equalTo: detailRecipeView.view.bottomAnchor, constant: 10),
            ingredientsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            ingredientsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            
            categoriesView.topAnchor.constraint(equalTo: ingredientsView.bottomAnchor),
            categoriesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            categoriesView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -20),
            categoriesView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
}
//MARK: - RecipeProfileDelegate
extension RecipeProfileViewController: RecipeProfileDelegate {
    func loadData(categoriesList: [String], cookingInfo: CookingInfo) {
        categoriesView.setText(categoriesList)
        ingredientsView.setDataAndsetupUI(ingredients: cookingInfo.ingredients,
                                          servingCount: cookingInfo.serving,
                                          timeCooking: cookingInfo.timeCooking)
    }
}
