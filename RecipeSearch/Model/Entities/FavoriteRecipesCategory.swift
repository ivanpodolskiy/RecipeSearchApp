//
//  FavoriteResipesCategory.swift
//  RecipeSearch
//
//  Created by user on 20.10.2023.
//

import Foundation
protocol FavoriteCategoryProtocol {
    var title: String {get set}
    var recipes: [RecipeProfileProtocol]? {get set}
}
struct FavoriteRecipesCategory: FavoriteCategoryProtocol {
    var title: String
    var recipes: [RecipeProfileProtocol]?
    init(from favoriteList: FavoriteList) {
        let name = favoriteList.nameCategory ?? ""
       self.title = name
        self.recipes = favoriteList.recipes?.compactMap {
            if let favoriteRecipe = $0 as? FavoriteRecipe { return RecipeProfile(favoriteRecipe: favoriteRecipe)}
            return nil
        } ?? []
    }
}
