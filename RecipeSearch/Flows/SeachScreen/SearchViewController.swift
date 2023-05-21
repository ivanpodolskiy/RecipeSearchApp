//
//  SearchViewController.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    var oldText: String = ""
    
    private let service = RecipeSreachService()
    private var result: [RecipeProfile]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupLayouts()
    }
    
    private let searchController: UISearchController = {
        let sb = UISearchController()
        sb.searchBar.translatesAutoresizingMaskIntoConstraints = false
        sb.searchBar.searchBarStyle = .minimal
        sb.searchBar.tintColor = UIColor.basic
        return sb
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
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
       // collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.title = "Recipe Search"
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
        
        guard let recipes = result else { return cell }
        let recipe = recipes[indexPath.row]
        cell.setupCell(with: recipe)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = result else { return }
        let res = item[indexPath.row]
        let recipeViewController = RecipeViewController(recipe: res)
        navigationController?.pushViewController(recipeViewController, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier, for: indexPath)
//        headerView.frame.size.height = 100
//        return headerView
//    }
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
