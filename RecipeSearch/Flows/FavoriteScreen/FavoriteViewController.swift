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
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Favorite Recipes"
        //set style text and add color for navigationItem.title
        setupViews()
        setupLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchRecipes()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupLayouts() {
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
    private func fetchRecipes() {
        do {
            self.favoriteRecipes = try context.fetch(FavoriteRecipes.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
        }
    }
}
//MARK: - TableView
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let item = favoriteRecipes else { return cell }
        
        cell.textLabel?.text = item[indexPath.row].title
        return  cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recipes = favoriteRecipes {
            return recipes.count
        }
        return 0
    }
}
