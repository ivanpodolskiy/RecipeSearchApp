//
//  SectionFavoriteRecipesProtocol.swift
//  RecipeSearch
//
//  Created by user on 20.10.2023.
//


protocol FavoriteRecipesSectionProtocol {
    var title: String {get set}
    var recipes: [RecipeProfileProtocol]? {get set}
}

struct FavoriteRecipesSection: FavoriteRecipesSectionProtocol {
    var title: String
    var recipes: [RecipeProfileProtocol]?
    
    init(from recipeSectionCD: RecipesSectionEntity) {
        self.title = recipeSectionCD.nameSection ?? ""
        self.recipes = getRecipes(form: recipeSectionCD)
    }
    
    private func getRecipes(form recipeSectionCD: RecipesSectionEntity) -> [RecipeProfileProtocol]?{
        recipeSectionCD.recipeProfileEntity?.compactMap {
           if let recipeProfileEntity = $0 as? RecipeProfileEntity { return RecipeProfile(recipeProfileEntity: recipeProfileEntity)}
           return nil
       }
    }
}
