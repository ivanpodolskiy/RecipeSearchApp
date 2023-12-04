//
//  SectionFavoriteRecipesProtocol.swift
//  RecipeSearch
//
//  Created by user on 20.10.2023.
//

import Foundation
protocol FavoriteRecipesSectionProtocol {
    var title: String {get set}
    var recipes: [RecipeProfileProtocol]? {get set}
}
struct FavoriteRecipesSection: FavoriteRecipesSectionProtocol {
    var title: String
    var recipes: [RecipeProfileProtocol]?
    init(from recipeSectionCD: RecipesSectionEntity) {
        let name = recipeSectionCD.nameSection ?? ""
       self.title = name
        self.recipes = recipeSectionCD.recipeProfileEntity?.compactMap {
            if let recipeProfileEntity = $0 as? RecipeProfileEntity { return RecipeProfile(recipeProfileEntity: recipeProfileEntity)}
            return nil
        } ?? []
    }
}
