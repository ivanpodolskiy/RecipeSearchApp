//
//  RecipeProfile.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//
struct RecipeProfile {
    let title: String
    let image: String
    let calories: Int
    let countIngredients: Int
    let recipeInfromation: RecipeInformation
    var isFavorite: Bool = false
    var url: String
    
    init(title: String, image: String, calories: Int, countIngredients: Int, recipeInfromation: RecipeInformation, isFavorite: Bool = false, url: String) {
        self.title = title
        self.image = image
        self.calories = calories
        self.countIngredients = countIngredients
        self.recipeInfromation = recipeInfromation
        self.isFavorite = isFavorite
        self.url = url
    }
    init(favoriteRecipe: FavoriteRecipe) {
        if let title = favoriteRecipe.title, let image = favoriteRecipe.image  {
            self.init(title: title, image: image, calories: 0, countIngredients: 0, recipeInfromation: RecipeInformation(healthlabels: [""], listIngredients: [""]), isFavorite: true, url: "")
        } else {
            self.init()
        }
    }
    
    init() {
        self.init(title: "Placeholder", image: "", calories: 0, countIngredients: 0, recipeInfromation: RecipeInformation(healthlabels: [""], listIngredients: [""]), isFavorite: true, url: "")
    }
   // var daily: [String: Total]
    
    //MARK: - добавить общее время готовки
    //totalTime
}

extension RecipeProfile {
    var description: String {
        return "Callo. \(calories). Ingre. \(countIngredients) "
    }
    
    func getFromFavrotieRecipe(_ favoriteRecipe: FavoriteRecipe)  {
        
    }
}

