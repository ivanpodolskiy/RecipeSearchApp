//
//  SearchViewController.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

import UIKit

fileprivate enum TypeDescription {
    case searching
    case filterSetting
    case dataError(description: String)
}

fileprivate enum ChildType {
    case filter
    case recipesCollection
}

class SearchViewController: UIViewController{
    private var presenter: SearchPresenterProtocol?
    private var throttle: Throttler?
    
    func setPresenter(_ presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        self.throttle = Throttler()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        showDisplayedDescription(for: .searching)
    }
    
    //MARK: - Outlets
    private var constraintDescriptionSearching: [NSLayoutConstraint]!
    private var constraintDescriptionFiltering: [NSLayoutConstraint]!
    private lazy var slideInTransitioningDelegate = PanelTransition()
    
    private  var filterController: FilterViewController?
    private  var collectionView: RecipesViewController?
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.tintColor = UIColor.basic
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.setImage(UIImage(systemName: "slider.horizontal.3"), for: .bookmark, state: .normal)
        return searchController
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    private func addDescriptionLabel() {
        view.addSubview(descriptionLabel)
    }
    
    private func setChildViewController(_ selectedChild: ChildType) {
        initAndSetupChildVC(typeVC: selectedChild, setupMethod: { child, constraintMethod in
            child.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(child.view)
            addChild(child)
            child.didMove(toParent: self)
            constraintMethod()
        })
    }
    
    private func initAndSetupChildVC(typeVC: ChildType, setupMethod: (UIViewController, () -> ()) -> ()) {
        switch typeVC {
        case .filter:
            guard let filterView = presenter?.createFilterView() as? FilterViewController else { return }
            filterController = filterView
            
            setupMethod(filterController!, setFilterConstraint)
        case .recipesCollection:
            guard let recipesView = presenter?.createRecpesView() as? RecipesViewController else { return}
            collectionView = recipesView
            setupMethod(collectionView!, setCollectionConstraint)
        }
    }
    
    private func removeChild(_ selectedChild: ChildType) {
        deinitChildVC(typeVC: selectedChild) { childVC in
            childVC.willMove(toParent: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }
    }
    
    private func deinitChildVC(typeVC: ChildType, removingMethod: (UIViewController) -> ()) {
        switch typeVC {
        case .filter:
            guard let filterController = filterController else { return }
            removingMethod(filterController)
            self.filterController = nil
        case .recipesCollection:
            guard let collectionView = collectionView else { return }
            removingMethod(collectionView)
            self.filterController = nil
        }
    }
    
    private func showDisplayedDescription(for type:  TypeDescription) {
        descriptionLabel.isHidden = false
        addDescriptionLabel()
        
        switch type {
        case .searching:
            setupSearchDescriptionConstraint()
            descriptionLabel.text = "Enter a what you have to search, like \"coffee and croissant\" or \"chicken enchilada\" to see how it works."
        case .filterSetting:
            setupFilterDescription()
            descriptionLabel.text = "Here you can change your filtering settings"
        case .dataError(let description):
            setupSearchDescriptionConstraint()
            descriptionLabel.text = description
        }
    }
    //MARK: - Layouts
    private func setFilterConstraint() {
        guard let filterController = filterController else { return }
        NSLayoutConstraint.activate([
            filterController.view.topAnchor.constraint(equalTo: searchController.searchBar.searchTextField.bottomAnchor),
            filterController.view.leftAnchor.constraint(equalTo: searchController.searchBar.leftAnchor, constant: 32),
            filterController.view.rightAnchor.constraint(equalTo: searchController.searchBar.rightAnchor, constant: -32),
            filterController.view.heightAnchor.constraint(equalToConstant: 160),
        ])
    }
    
    private func setCollectionConstraint() {
        guard let collectionView = collectionView else { return }
        NSLayoutConstraint.activate([
            collectionView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupSearchDescriptionConstraint() {
        if constraintDescriptionSearching == nil {
            constraintDescriptionSearching = [descriptionLabel.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 5),
                                              descriptionLabel.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 24),
                                              descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24)]
        }
        if constraintDescriptionFiltering != nil{
            NSLayoutConstraint.deactivate(constraintDescriptionFiltering)
            constraintDescriptionFiltering = nil
        }
        NSLayoutConstraint.activate(constraintDescriptionSearching)
    }
    
    private func setupFilterDescription(){
        if constraintDescriptionFiltering == nil {
            constraintDescriptionFiltering = [descriptionLabel.topAnchor.constraint(equalTo: filterController!.view.bottomAnchor, constant: 10),
                                              descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        }
        
        if constraintDescriptionFiltering != nil {
            NSLayoutConstraint.deactivate(constraintDescriptionSearching)
            constraintDescriptionSearching = nil
        }
        NSLayoutConstraint.activate(constraintDescriptionFiltering)
    }
}
//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        removeChild(.filter)
        showDisplayedDescription(for: .searching)
        searchController.searchBar.showsBookmarkButton = false
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {//ref.     delete
        removeChild(.recipesCollection)
        showDisplayedDescription(for: .searching)
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "slider.horizontal.3"), for: .bookmark, state: .normal)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if filterController != nil {
            changeSearchBarImage(in: searchBar, imageSystemName: "slider.horizontal.3")
            removeChild(.filter)
            showDisplayedDescription(for: .searching)
        } else {
            changeSearchBarImage(in: searchBar, imageSystemName: "xmark")
            setChildViewController(.filter)
            showDisplayedDescription(for: .filterSetting)
        }
    }
    
    private func changeSearchBarImage(in searchBar: UISearchBar, imageSystemName: String) {
        searchBar.setImage(UIImage(systemName: imageSystemName), for: .bookmark, state: .normal)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if descriptionLabel.isHidden == false  {
            showRecipesCollection()
        }
        serchRecipe(use: searchText)
    }
    
    private func showRecipesCollection() {
        descriptionLabel.isHidden = true
        descriptionLabel.removeFromSuperview()
        setChildViewController(.recipesCollection)
    }
    
    private func serchRecipe(use searchText: String) {
        throttle?.throttle(delay: 0.3) { [weak self] in
            guard let self = self else { return }
            presenter?.searchRecipes(from: searchText)
        }
    }
}
//MARK: - SearchControllerDelegate
extension SearchViewController: SearchControllerDelegate {
    func updateText(_ userFriendlyDescription: String) {
        DispatchQueue.main.async {
            self.showDisplayedDescription(for: .dataError(description: userFriendlyDescription))
            self.removeChild(.recipesCollection)
        }
    }
    
    func presentAlert(_ alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
