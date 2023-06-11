//
//  SearchViewController.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    //MARK: - Properties
    private var oldText: String = ""
    private let RecipeService = RecipeSreachService()
    private var result: [RecipeProfile]?
    private let favoriteRecipeService = FavoriteRecipeService()
    private lazy var slideInTransitioningDelegate = SelectionCategoryManager()
    
    //MARK: - View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.title = "Recipe Search"
        startLaunchAnimtaion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        upadteRecipesStatus()
        
    }
    //MARK: - Outlets
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = UIColor.basic
        return searchController
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewWillLayoutSubviews() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func upadteRecipesStatus() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.favoriteRecipeService.updateStatusRecipes(for: &result)
        }
    }
    
    //MARK: - Animation function
    
    private func startLaunchAnimtaion() {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {return }
        
        let viewA = UIView()
        viewA.backgroundColor = .basic
        sceneDelegate.window?.addSubview(viewA)
        viewA.frame = view.bounds
        
        let positionOnX: CGFloat = 15
        let positionOnY: CGFloat = 14
        
        let width = (tabBarController?.tabBar.bounds.width)! - positionOnX * 2
        let height: CGFloat = 77
        
        let frame =  CGRect(x: positionOnX, y: ((tabBarController?.tabBar.frame.minY)! - positionOnY) , width: width, height: height)
        
        lazy var animator1 =  {             UIViewPropertyAnimator(duration:0.5, curve: .easeOut) {
                viewA.frame =  frame
                viewA.layer.cornerRadius = height / 2
            }
        }()
        
        lazy var animator2 = {
            UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
                viewA.layer.opacity = 0
            }
        }()
        animator1.addCompletion {_ in
            animator2.startAnimation()
        }
        animator2.addCompletion {  _ in
            viewA.removeFromSuperview()
        }
        animator1.startAnimation()
    }
    
    //MARK: - Actions
    @objc func switchFavoriteStatus(sender: UIButton) {
        let index = sender.tag
        guard var selectedRecipe = result?[index] else {
            return
        }
        switch selectedRecipe.isFavorite {
        case true:
            guard let  categoryName = sender.titleLabel?.text else { return }
            selectedRecipe.isFavorite = false
            favoriteRecipeService.removeRecipe(recipeName: selectedRecipe.title, categoryName: categoryName)
            sender.tintColor = .white
            result?[index] = selectedRecipe
            
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
                    result?[index] = selectedRecipe
                    
                case .newCategory(let name):
                    self.favoriteRecipeService.addFavoriteRecipe(selectedRecipe, nameCategory: name, сategoryExists: false)
                    selectedRecipe.isFavorite = true
                    sender.tintColor = .yellow
                    result?[index] = selectedRecipe
                }
            }
            present(selectionCategoryView, animated: true)
        }
    }
}
//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let result = result else { return 0 }
        return  result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
        guard let recipe = result?[indexPath.row] else { return cell }
        cell.setupCell(with: recipe, index: indexPath)
        cell.buttonFavorite.addTarget(self, action: #selector(switchFavoriteStatus(sender: )), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = result else { return }
        let res = item[indexPath.row]
        let recipeViewController = RecipeViewController(recipe: res)
        let cell =  collectionView.cellForItem(at: indexPath) as? RecipeCell
        recipeViewController.completion = { status in
            if let status = status {
                cell?.setColorToFavoriteButton( status)
            }
        }
        navigationController?.pushViewController(recipeViewController, animated: true)
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout{
    private enum LayoutConstant {
        static let spacing: CGFloat = 10
        static let itemHeight: CGFloat = 250
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstant.spacing, left: LayoutConstant.spacing, bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidth(for: view.frame.width, spacing: LayoutConstant.spacing)
        return CGSize(width: width, height: LayoutConstant.itemHeight)
    }
    
    private func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itmesInRow: CGFloat = 2
        let totalSpacing: CGFloat = 2 * spacing + (itmesInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itmesInRow
        return finalWidth - 2
    }
}
//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return}
        if query.count > 2 && query != oldText {
            oldText = query
            DispatchQueue.global().async {
                self.RecipeService.searchRecipe(search: query) { recipe in
                    self.result = recipe
                    self.favoriteRecipeService.updateStatusRecipes(for: &self.result)
                    
                    DispatchQueue.main.async {
                        let indexPaths = self.collectionView.indexPathsForVisibleItems
                        if indexPaths.count > 0 {
                            self.collectionView.reloadItems(at: indexPaths)
                        } else {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        } else if  query.count < 3 && result != nil  {
            oldText = ""
            result = nil
            self.collectionView.reloadData()
        }
    }
}

