//
//  TabBarItem.swift
//  RecipeSearch
//
//  Created by user on 22.05.2023.
//

import UIKit

enum CustomTabBarItem: String, CaseIterable {
    case search
}

extension CustomTabBarItem {
    var viewController: UIViewController {
        switch self {
        case .search:
            let nc = UINavigationController(rootViewController: SearchViewController())
            return nc
        }
    }
    var icon: UIImage? {
        switch self {
        case .search:
            return UIImage(systemName: "magnifyingglass")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        }
    }
    var selectedIcon: UIImage? {
        switch self {
        case .search:
            return UIImage(systemName: "magnifyingglass")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        }
    }
    var title: String {
        return self.rawValue.capitalized
    }
}
