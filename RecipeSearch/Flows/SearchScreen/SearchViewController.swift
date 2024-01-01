//
//  SearchViewController.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

import UIKit

enum TypeDescription {
    case searching
    case filterSetting
    case dataError
}
enum ChildVC {
    case filter
    case recipesCollection
}

class SearchViewController: UIViewController{
    var presenter: SearchPresenterProtocol?
    private var searchTimer: Timer?
    
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
    private lazy var slideInTransitioningDelegate = SelectionSectionManagerView()
    
    private var filterController: FilterViewController!
    private var collectionView: RecipesViewController!
    
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
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - View functions
    private func setDescriptionLabel() {
        view.addSubview(descriptionLabel)
    }
    private func setChildViewController(_ selectedVC: ChildVC) {
        func setVC(vc: UIViewController) {
            view.addSubview(vc.view)
            addChild(vc)
            vc.didMove(toParent: self)
        }
        switch selectedVC {
        case .filter:
            guard let filterView = presenter?.createFilterView() as? FilterViewController else { return }
            filterController = filterView
            setVC(vc: filterController)
            setFilterConstraint()
        case .recipesCollection:
            guard let recipesView = presenter?.createRecpesView() as? RecipesViewController else { return}
            collectionView = recipesView
            setVC(vc: collectionView)
            setCollectionConstraint()
        }
    }
    private func dismissChildViewController(_ selectedChild: ChildVC) {
        var childVC: UIViewController!
        func dismis() {
            childVC.willMove(toParent: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent() //ref.
        }
        switch selectedChild {
        case .filter:
            if filterController != nil {
            childVC =  filterController } else { return }
            dismis()
            filterController = nil
        case .recipesCollection:
            if collectionView != nil {
            childVC =  collectionView } else { return }
            dismis()
            collectionView = nil
        }
    }
    private func showDisplayedDescription(for type:  TypeDescription, with description: String = "") {
        descriptionLabel.isHidden = false
        setDescriptionLabel()
        switch type {
        case .searching:
            setupSearchDescriptionConstraint()
            descriptionLabel.text = "Enter a what you have to search, like \"coffee and croissant\" or \"chicken enchilada\" to see how it works."
        case .filterSetting:
            setupFilterDescription()
            descriptionLabel.text = "Here you can change your filtering settings"
        case .dataError:
            setupSearchDescriptionConstraint()
            descriptionLabel.text = description
        }
    }
    //MARK: - Layouts
    private func setFilterConstraint() {
        NSLayoutConstraint.activate([
            filterController.view.topAnchor.constraint(equalTo: searchController.searchBar.searchTextField.bottomAnchor),
            filterController.view.leftAnchor.constraint(equalTo: searchController.searchBar.leftAnchor, constant: 32),
            filterController.view.rightAnchor.constraint(equalTo: searchController.searchBar.rightAnchor, constant: -32),
            filterController.view.heightAnchor.constraint(equalToConstant: 160),
        ])
    }
    private func setCollectionConstraint() {
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
            constraintDescriptionFiltering = [descriptionLabel.topAnchor.constraint(equalTo: filterController.view.bottomAnchor, constant: 10),
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
    func willPresentSearchController(_ searchController: UISearchController) { //ref. -
        dismissChildViewController(.filter)
        showDisplayedDescription(for: .searching)
        searchController.searchBar.showsBookmarkButton = false
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {//ref.     delete
        dismissChildViewController(.recipesCollection)
        showDisplayedDescription(for: .searching)
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "slider.horizontal.3"), for: .bookmark, state: .normal)
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if filterController != nil {
            searchBar.setImage(UIImage(systemName: "slider.horizontal.3"), for: .bookmark, state: .normal)
            dismissChildViewController(.filter)
            showDisplayedDescription(for: .searching)
        } else {
            searchBar.setImage(UIImage(systemName: "xmark"), for: .bookmark, state: .normal)
            setChildViewController(.filter)
            showDisplayedDescription(for: .filterSetting)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTimer?.invalidate()
        if descriptionLabel.isHidden == false  {
            descriptionLabel.isHidden = true
            descriptionLabel.removeFromSuperview()
            setChildViewController(.recipesCollection)
        }
        let interval: TimeInterval  = 0.3
        searchTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.searchRecipes(from: searchText)
        })
    }
}
//MARK: - SearchControllerDelegate
extension SearchViewController: SearchControllerDelegate {
    func updateText(_ userFriendlyDescription: String) {
        DispatchQueue.main.async {
            self.showDisplayedDescription(for: .dataError, with: userFriendlyDescription)
            self.dismissChildViewController(.recipesCollection)
            
        }
    }
    
    func presentAlert(_ alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

