//
//  RecipesViewController.swift
//  RecipeSearch
//
//  Created by user on 17.09.2023.
//

import UIKit

class RecipesViewController: UIViewController{  
    private var lastCurrentOffset: CGFloat = 0

    private var presenter: RecipesPresenterProtocol!
    private var recipes: [RecipeProfileProtocol]?
    private let transition = PanelTransition()
    
    private var isCollectionHidden: Bool = true {
        willSet { self.collectionView.isHidden = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .selected
        view.translatesAutoresizingMaskIntoConstraints = false
        setupCollectionView()
    }
    
    func setPresenter(_ presenter: RecipesPresenterProtocol) {
        self.presenter = presenter
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spaceBottom: CGFloat = 40.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: spaceBottom, right: 0)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
       
    private func setupCollectionView() {
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
        collectionView.register(RecipesViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecipesViewHeader.indentifier)
        
        activeLayoutForCollectioView()
    }
    
    private func activeLayoutForCollectioView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo:view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension RecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let result = recipes else { return 0 }
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecipesViewHeader.indentifier, for: indexPath) as! RecipesViewHeader
        guard let recipes = recipes else { return headerView}
        headerView.setRecipesCount(number: recipes.count)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
        guard let recipe = recipes?[indexPath.row] else { 
            return cell
        }
        presenter.configureCell(cell, with: recipe, tag: indexPath.row)
        cell.addTargetToButton(target: self, action: #selector(switchFavoriteStatus))
        return cell
    }
    
    @objc private func switchFavoriteStatus(sender: UIButton) {
        let index = sender.tag //ref. i need to get indexPath.row's cell
        guard let selectedRecipe = recipes?[index] else { return }
        presenter.switchFavoriteStatus(selectedRecipe, atIndex: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipes = recipes else { return }
        let recipe = recipes[indexPath.row]
        
        presenter.pushRecipeProfileScreen(with: recipe) { [weak self] isFavorite  in
            guard let self = self, let isFavorite = isFavorite else { return }
            DispatchQueue.main.async {
                self.recipes![indexPath.row].isFavorite = isFavorite
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 50)
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension RecipesViewController: UICollectionViewDelegateFlowLayout{
    private enum LayoutConstant {
        static let spacing: CGFloat = 10
        static let itemHeight: CGFloat = 240
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
//MARK: - UIScrollViewDelegate
extension RecipesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var currentOffset = scrollView.contentOffset.y
        if lastCurrentOffset  < currentOffset && currentOffset > 50 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else if lastCurrentOffset > currentOffset {
            currentOffset += 24
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        lastCurrentOffset = currentOffset
    }
}
//MARK: - RecipesViewDelegate
extension RecipesViewController: RecipesControllerDelegate {
    func presentCustomSheet(_ viewController: UIViewController) {
        viewController.transitioningDelegate = transition
        viewController.modalPresentationStyle  = .custom
        DispatchQueue.main.async {
            self.present(viewController, animated: true)
        }
    }
    
    func updateFavoriteStatus(isFavorite: Bool, index: Int) {
        recipes?[index].isFavorite = isFavorite
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    func updateItems(recipe result: [RecipeProfileProtocol]?) {
        recipes = result
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.collectionView.performBatchUpdates ({
                self.collectionView.reloadSections(IndexSet(integer: 0))
                self.collectionView.isHidden = false
            })
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let navigationController = navigationController else { return }
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: animated) }
}