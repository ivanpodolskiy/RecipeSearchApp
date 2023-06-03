//
//  SearchViewController.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
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
    
    //MARK: - Properties
    private var oldText: String = ""
    private let service = RecipeSreachService()
    private var result: [RecipeProfile]?
    private let favoriteRecipeService = FavoriteRecipeService()
        
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        favoriteRecipeService.updateStatusRecipes(for: &result)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.title = "Recipe Search"
    }
    
    //MARK: - Actions
    @objc func switchFavoriteStatus(sender: UIButton) {
        let index = sender.tag
        guard var selectedRecipe = result?[index] else {
            return
        }
        switch selectedRecipe.isFavorite {
        case true:
            selectedRecipe.isFavorite = false
            favoriteRecipeService.removeFavotireRecipe(name: selectedRecipe.title)
            sender.tintColor = .white
        case false:
            selectedRecipe.isFavorite = true
            favoriteRecipeService.addFavoriteRecipe(selectedRecipe)
           // addFavoriteRecipe(selectedRecipe)
            sender.tintColor = .yellow
        }
        result?[index] = selectedRecipe
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
                self.service.searchRecipe(search: query) { recipe in
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

