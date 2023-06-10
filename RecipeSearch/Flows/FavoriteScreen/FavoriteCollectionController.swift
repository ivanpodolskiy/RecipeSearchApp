//
//  FavoriteCollectionController.swift
//  RecipeSearch
//
//  Created by user on 02.06.2023.
//

import UIKit
import CoreData

class FavoriteCollectionController: UIViewController {
    //MARK: - Outlets
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: - Properties
    private var favoriteCategories: [FavoriteList]?
    private let favoriteRecipesService = FavoriteRecipeService()
    
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Favorite List"
        setupViews()
        setupLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateCollectionView()
    }
    private func setupViews() {
        collectionView.register(FavoriteRecipeCell.self, forCellWithReuseIdentifier: FavoriteRecipeCell.identifier)
        collectionView.register(FavoriteHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoriteHeader.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setupLayouts() {
        navigationItem.rightBarButtonItem = getBarButtonItem()
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.3)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 30, trailing: 10)
        section.supplementaryContentInsetsReference = .automatic
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let header =  NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(25)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        return header
    }
    
    //MARK: Actions
    @objc func removeAll(sender: UIBarButtonItem) {
        favoriteRecipesService.deleteAll()
        updateCollectionView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
//MARK: - Functions
extension FavoriteCollectionController {
    private func updateCollectionView() {
        self.favoriteCategories = favoriteRecipesService.fetchAllCategories()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func getBarButtonItem() ->  UIBarButtonItem {
        let barButtonItem =  UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAll(sender: )))
        return barButtonItem
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FavoriteCollectionController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let list = favoriteCategories {
            return list.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let list = favoriteCategories else { return 0}
        guard let recipes = list[section].recipes else { return 0}
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteRecipeCell.identifier, for: indexPath) as! FavoriteRecipeCell
        guard let list = favoriteRecipesService.fetchRecipes(section: indexPath.section) else  { return cell }
        let item = list[indexPath.row]
        cell.setupCell(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoriteHeader.identifier, for: indexPath) as! FavoriteHeader
            guard let list = favoriteRecipesService.fetchAllCategories(), let nameCategory = list[indexPath.section].nameCategory   else { return header}
            header.setText(nameCategory)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
