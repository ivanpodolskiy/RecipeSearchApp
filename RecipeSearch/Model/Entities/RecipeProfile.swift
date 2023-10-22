//
//  RecipeProfile.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

protocol RecipeProfileProtocol {
    var title: String {get}
    var stringImage: String {get} //ref.
    var totalCalories: Int {get}
    var calories: Int {get}
    var ingredientLines: [String] {get}
    var healthLabels: [String] {get}
    var isFavorite: Bool {get set}
    var url: String {get}
    var serving: Int {get}
    var description: String { get}
}
struct RecipeProfile: RecipeProfileProtocol {
    let totalCalories: Int
    let serving: Int
    let title: String
    let stringImage: String
    let ingredientLines: [String]
    let healthLabels: [String]
    var isFavorite: Bool = false
    var url: String
    
    var countIngredients: Int {
        get {
            return ingredientLines.count
        }
    }
    var description: String {get{
        return "\(calories) kcal. Ingre: \(countIngredients) "
    }}
    
    var calories: Int {
        get {
            if serving == 0 { return 0 }
            return (totalCalories / serving)
        }
    }
        
    init(title: String, image: String, totalCalories: Int, isFavorite: Bool = false, url: String, serving: Int, healthLabels: [String], ingredientLines: [String]) {
        self.healthLabels = healthLabels
        self.ingredientLines = ingredientLines
        self.title = title
        self.stringImage = image
        self.isFavorite = isFavorite
        self.url = url
        self.serving = serving
        self.totalCalories = totalCalories

    }
    init(favoriteRecipe: FavoriteRecipe) { //ref.
        let totalCalories = Int(favoriteRecipe.totalCalories)
        let servings = Int(favoriteRecipe.serving)

        if  let title = favoriteRecipe.title,
            let image = favoriteRecipe.image,
            let url = favoriteRecipe.url,
            let healthLabels = favoriteRecipe.healthLabels,
            let ingredientLines = favoriteRecipe.ingredients {
            
            self.init(title: title, image: image,
                      totalCalories: totalCalories, isFavorite: true,
                      url: url, serving: servings,
                      healthLabels: healthLabels, ingredientLines: ingredientLines)
        } else {
            self.init()
        }
    }
    init() {
        self.init(title: "Recipe", image: "", totalCalories: 0, isFavorite: true, url: "", serving: 0,  healthLabels: [""], ingredientLines: [""]) //ref.
    }
}
