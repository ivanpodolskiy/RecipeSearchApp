//
//  RecipeCollectionView.swift
//  RecipeSearch
//
//  Created by user on 16.05.2023.
//

import UIKit

class RecipeProfileViewController: UIViewController  {
    private var presenter: RecipeProfilePresenterProtocol!
    
    //MARK: - Ountlets
    private let detailRecipeView = DetailRecipeHeaderView()
    private let ingredientsView = IngredientsView()
    private let catehoriesView = CategoriesView()
    private let transition = PanelTransition()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    func setPreseter(presenter: RecipeProfilePresenterProtocol) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        view.backgroundColor = .white
        presenter.loadRecipe()
    }
    
    override func viewDidLayoutSubviews() {
        addSubviewAndSetupLayout()
        setTargets()
    }
    
    private func addSubviewAndSetupLayout() {
        view.addSubview(scrollView)
        view.addSubview(ingredientsView)
        view.addSubview(catehoriesView)
        scrollView.addSubview(detailRecipeView)
        scrollView.addSubview(ingredientsView)
        scrollView.addSubview(catehoriesView)
        setupLayoutConstraint()
    }
    
    private func setupLayoutConstraint() {
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
    private func setTargets() {
        detailRecipeView.informationView.buttonFavorite.addTarget(self, action: #selector(switchFavoriteStatus(sender: )), for: .touchUpInside)
        detailRecipeView.informationView.linkButton.addTarget(self, action: #selector(showWebScreen(sender: )), for: .touchUpInside)
    }
    //MARK: - Actions
    @objc func showWebScreen(sender: UIButton) {
        presenter.pushWebViewController()
    }
    @objc func switchFavoriteStatus(sender: UILabel) {
        presenter.switchFavoriteStatus(nil, with: nil)
    }
}
//MARK: - RecipeProfileDelegate
extension RecipeProfileViewController: RecipeProfileDelegate {
    func presentCustomSheet(_ viewController: UIViewController) {
        viewController.transitioningDelegate = transition
        viewController.modalPresentationStyle = .custom
        DispatchQueue.main.async { self.present(viewController, animated: true) }
    }
    
    func presentError(_ userFriendlyDescription: String) {
        print(userFriendlyDescription)
    }
    
    func sendDataToController(recipe: RecipeProfileProtocol) {
        setData(recipe)
    }
    
    private func setData(_ recipe: RecipeProfileProtocol) {
        self.detailRecipeView.loadDataToViews(title: recipe.title, isFavorite: recipe.isFavorite)
        self.ingredientsView.setInformation(ingredients: recipe.ingredientLines)
        self.detailRecipeView.informationView.valuesView.setData(countServings: recipe.serving,  countCalories: recipe.calories) //ref.
        self.catehoriesView.setText(recipe.healthLabels)
    }
    
    func setImage(image: UIImage?) {
        self.detailRecipeView.loadImage(image: image ??   UIImage(named: "placeholder")!)
    }
    
    func updateFavoriteStatus(_ isFavorite: Bool) {
        detailRecipeView.updateButtonColor(isFavorite: isFavorite)
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
}
