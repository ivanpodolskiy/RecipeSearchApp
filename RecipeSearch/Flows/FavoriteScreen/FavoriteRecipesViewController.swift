//
//  FavoriteCollectionController.swift
//  RecipeSearch
//
//  Created by user on 02.06.2023.
//

import UIKit
import CoreData

class FavoriteRecipesViewController: UIViewController {
    private let alertUtility = AlertUtility() //ref
    private var presenter: FavoriteRecipesPresenterProtocol?

    private var favoriteSections: [FavoriteRecipesSectionProtocol]? {
        willSet {
            let status = newValue?.isEmpty == false
            isEnabledRightBarButton(status)
        }
    }
    func setPresenter(_ presenter: FavoriteRecipesPresenterProtocol) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        registerCollectionView()
        navigationItem.leftBarButtonItem = getLeftBarButtonItem()
        navigationItem.rightBarButtonItem = getRightBarButtomItem()
        updateCollectionViewLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let presenter = presenter { presenter.fetchFavoriteRecipes() }
    }
    override func viewDidLayoutSubviews() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    private func registerCollectionView() {
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
        collectionView.register(FavoriteViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoriteViewHeader.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private func getLeftBarButtonItem() ->  UIBarButtonItem {
        let barButtonItem =  UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAllSections(sender: )))
        barButtonItem.isEnabled = false
        return barButtonItem
    }
    private func getRightBarButtomItem() -> UIBarButtonItem {
        let barButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSection(sender: )))
        return barButtonItem
    }
    private func isEnabledRightBarButton(_ status:Bool ) {
        navigationItem.leftBarButtonItem?.isEnabled = status
    }
    //MARK: - UICollectionViewCompositionalLayout
    private func updateCollectionViewLayout(){
        let collectionViewlLayout =  getCollectionViewLayout()
        collectionView.setCollectionViewLayout(collectionViewlLayout, animated: false)
    }
    private func getCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let hasItems = self.hasItemsInSection(section: sectionIndex)// Replace with your data source
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
                    .fractionalHeight(1)))
            let heightDimension: NSCollectionLayoutDimension = hasItems ? .estimated(300)  : .estimated(1)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(250), heightDimension: heightDimension ), subitems: [item])
            let sectionLayout = NSCollectionLayoutSection(group: group)
            if hasItems {
                sectionLayout.orthogonalScrollingBehavior = .groupPaging
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
            } else {
                sectionLayout.orthogonalScrollingBehavior =  .none
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 16)
            }
            sectionLayout.interGroupSpacing = 15
            sectionLayout.supplementaryContentInsetsReference = .automatic
            sectionLayout.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
            return sectionLayout
        }
        return layout
    }
    private func hasItemsInSection(section: Int) -> Bool {
        guard let favoriteSections = favoriteSections else { return false }
        guard let recipes = favoriteSections[section].recipes, recipes.count != 0  else { return false }
        return true
    }
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let supplementaryItem =  NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(25)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        supplementaryItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 23)
        return supplementaryItem
    }
}
//MARK: - Action | Alerts
extension FavoriteRecipesViewController {
    enum TypeAlert {
        case creating
        case clrearing( Int?)
    }
    @objc private func removeAllSections(sender: UIBarButtonItem) { showAlert(use: .clrearing(nil)) }
    @objc private func addSection(sender: UIBarButtonItem) { showAlert(use: .creating) }
    
    @objc  private func switchFavoriteStatus(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: buttonPosition) {
            let section = indexPath.section
            let row = indexPath.row//  need to get indexPath.row's cell
            presenter?.removeItem(with: row, indexSection: section)
        }
    }
    @objc func handleTextFieldTextChanged(sender: UITextField) {
        if let alertController = presentedViewController as? UIAlertController, let text = sender.text{
            alertController.actions[0].isEnabled = !text.isEmpty
        }
    }
    private func removeNeededSection(indexSection: Int) {
        showAlert(use: .clrearing(indexSection) )
    }
    
    private  func showAlert(use type: TypeAlert)  {
        let alertController = {
            switch type {
            case .clrearing(let indexSetion): return self.runClearingAlert(indexSection: indexSetion)
            case .creating: return self.runCreatingAlert()
            }
        }
        present(alertController(), animated: true)
    }
    private func runClearingAlert(indexSection: Int?) -> UIAlertController{
        let massage  = indexSection != nil ? "Do you want to remove \(indexSection! + 1)th section of recipes" : "Do you want to remove all your favorite recipes"
        let alertController = UIAlertController(title: "Removing", message: massage, preferredStyle: .alert)
        let removeAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if indexSection == nil {
                self.presenter?.removeAllRecipes()
            } else {
                self.presenter?.removeSection(section: indexSection!)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    private func runCreatingAlert() -> UIAlertController{
        let alertController = alertUtility.textInputAlert(title: "Creating section", message: "Type name for new section", placeholder: "", target: self, handleTextFieldTextChanged: #selector(handleTextFieldTextChanged)) { [weak self] text in
            guard let self = self, let text = text else { return }
            self.presenter?.addSection(title: text)
        }
        return alertController
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FavoriteRecipesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let  favoriteCategories = favoriteSections else { return 0}
        return favoriteCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = favoriteSections else { return 0}
        guard let recipes = categories[section].recipes else { return 0}
        return recipes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
        guard let favoriteCategories = favoriteSections else { return cell }
        guard let recipes = favoriteCategories[indexPath.section].recipes else { return cell}
        let recipe = recipes[indexPath.row]
        presenter?.configureCell(cell, with: recipe, tag: indexPath.row)
        cell.favoriteButton.addTarget(self, action: #selector(switchFavoriteStatus(sender: )), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoriteViewHeader.identifier, for: indexPath) as! FavoriteViewHeader
            guard let favoriteSections = favoriteSections else { return header}
            let titleSection = favoriteSections[indexPath.section].title
            let count = favoriteSections[indexPath.section].recipes?.count
            header.setSectionDesctiption(title: titleSection, countItems: count ?? 0)

            header.updatingTitleHandler = { [ weak self] title in
                guard let self = self else { return }
                presenter?.renameSection(title: title, indexSection: indexPath.section)
            }
            header.deleteActionHandler = { [weak self] in
                guard let self = self else { return}
                self.removeNeededSection(indexSection: indexPath.section)
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
//MARK: - UICollectionViewDelegate
extension FavoriteRecipesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let favoriteCategories = favoriteSections,
              let recipes = favoriteCategories[indexPath.section].recipes else { return }
        let recipe = recipes[indexPath.row]
        presenter?.pushResipeScreen(with: recipe) { _ in }
    }
    
}
//MARK: - FavoriteRecipesDelegate
extension FavoriteRecipesViewController: FavoriteRecipesDelegate {
    func removeFavoriteSection(section: Int, currectFavoriteRecipesCategories: [FavoriteRecipesSectionProtocol]) {
        self.favoriteSections = currectFavoriteRecipesCategories
            DispatchQueue.main.async {
                self.collectionView.performBatchUpdates({
                    self.collectionView.deleteSections(IndexSet(integer: section) )
                }) { _ in
                    self.collectionView.reloadData()
                }
            }
    }
    func removeFavoriteRecipe(section: Int, index: Int, currectFavoriteRecipesCategories: [FavoriteRecipesSectionProtocol] ) {
        self.favoriteSections = currectFavoriteRecipesCategories
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates({
                let indexPath = IndexPath(row: index, section: section)
                self.collectionView.deleteItems(at: [indexPath])
            }) { _ in
                let indexSet = IndexSet(integer: section)
                self.collectionView.reloadSections(indexSet)
            }
        }
    }
    func removeAllSections(currectFavoriteRecipesCategories: [FavoriteRecipesSectionProtocol]) {
        self.favoriteSections = currectFavoriteRecipesCategories
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates({
                let sections = 0..<self.collectionView.numberOfSections
                let indexSet = IndexSet(integersIn: sections)
                self.collectionView.deleteSections(indexSet)
            })
        }
    }
    func updateCollectionView(favoriteRecipesCategories: [FavoriteRecipesSectionProtocol]) {
        self.favoriteSections = favoriteRecipesCategories
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
