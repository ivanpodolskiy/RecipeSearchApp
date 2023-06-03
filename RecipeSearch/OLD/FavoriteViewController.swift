//
//  FavoriteViewController.swift
//  RecipeSearch
//
//  Created by user on 27.05.2023.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    //MARK: - Outlets
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
        
    //MARK: - Properties
    private var favoriteRecipes: [FavoriteRecipes]?
    private let favoriteRecipeService = FavoriteRecipeService()
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorite Recipes"
        view.addSubview(tableView)
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTableView()
    }

    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

//MARK: - Functions
extension FavoriteViewController {
    private func updateTableView() {
        self.favoriteRecipes = favoriteRecipeService.fetchFavoriteRecipes()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
    }
}
//MARK: - TableView
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let items = favoriteRecipes else { return cell }
        
        cell.textLabel?.text = items[indexPath.row].title
        return  cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recipes = favoriteRecipes {
            return recipes.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            guard let items = self.favoriteRecipes else { return }
            if let title = items[indexPath.row].title {
                self.favoriteRecipeService.removeFavotireRecipe(name: title)
                self.updateTableView()
            }
          
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
