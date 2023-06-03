//
//  TabBarItem.swift
//  RecipeSearch
//
//  Created by user on 22.05.2023.
//

import UIKit

enum CustomTabBarItem: String, CaseIterable {
    case search
    case favorite
}

extension CustomTabBarItem {
    var viewController: UIViewController {
        switch self {
        case .search:
            let nc = UINavigationController(rootViewController: SearchViewController())
            return nc
            
        case .favorite:
            let nc = UINavigationController(rootViewController: FavoriteCollectionController())
            return nc
        }
    }
    var icon: UIImage? {
        switch self {
        case .search:
            return UIImage(systemName: "magnifyingglass")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
            
        case .favorite:
            return UIImage(systemName: "star")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        }
    }
    var selectedIcon: UIImage? {
        switch self {
        case .search:
            return UIImage(systemName: "magnifyingglass")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
            
        case .favorite:
            return UIImage(systemName: "star.fill")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        }
        
    }
    var title: String {
        return self.rawValue.capitalized
    }
}
