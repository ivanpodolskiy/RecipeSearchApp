//
//  RecipeProfile.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

protocol RecipeProfileProtocol {
    var title: String {get}
    var imageURL: String {get}
    var calories: Int {get}
    var categories: [String] {get}
    var isFavorite: Bool {get set}
    var url: String {get}
    var cookingInfo: CookingInfo {get}
    var macronutrientsInfo: MacronutrientsInfo {get}
    var description: String { get}
    var totalCalories: Int {get} 
}

struct CookingInfo {
    let serving: Int
    let ingredients: [String]
    let timeCooking: Int
    
    var countIngredients: Int {
        get {
            return ingredients.count
        }
    }
}

struct RecipeProfile: RecipeProfileProtocol {
    let totalCalories: Int
    let categories: [String]
    let macronutrientsInfo: MacronutrientsInfo
    let cookingInfo: CookingInfo
    let title: String
    let imageURL: String
    
    var isFavorite: Bool = false
    var url: String
    
    var description: String {get{ return "\(calories) kcal. Ingre: \(cookingInfo.countIngredients)"}}
    
    var calories: Int {
        get {
            if cookingInfo.serving == 0 { return 0 }
            return (totalCalories / cookingInfo.serving)
        }
    }
    
    init(macronutrientsInfo: MacronutrientsInfo, totalCalories: Int, cookingInfo: CookingInfo, title: String, imageURL: String, categories: [String], isFavorite: Bool = false, url: String) {
        self.macronutrientsInfo = macronutrientsInfo
        self.totalCalories = totalCalories
        self.cookingInfo = cookingInfo
        self.title = title
        self.imageURL = imageURL
        self.categories = categories
        self.isFavorite = isFavorite
        self.url = url
    }
    
    init(recipeResult: Recipe) {
        self.init()
        let macronutrientsInfo = getMacronutrientsInfo(from: recipeResult)
        
        let timeCooking = recipeResult.totalTime
        let serving = recipeResult.yield
        let ingredients = recipeResult.ingredientLines
        let title = recipeResult.label
        let imageURL = recipeResult.image
        let categories = recipeResult.healthLabels
        let url = recipeResult.url
        let totalCalories = Int(recipeResult.calories ?? 0)
        let cookingInfo = CookingInfo(serving: serving, ingredients: ingredients, timeCooking: timeCooking)
    
        self.init(macronutrientsInfo: macronutrientsInfo, totalCalories: totalCalories, cookingInfo: cookingInfo, title: title, imageURL: imageURL, categories: categories, url: url)
    }
    
    init(recipeProfileEntity: RecipeProfileEntity) {
        let totalCalories = Int(recipeProfileEntity.totalCalories)
        let serving = Int(recipeProfileEntity.serving)
        let ingredients = recipeProfileEntity.ingredients ?? []
        let timeCooking = Int(recipeProfileEntity.timeCooking)

        let cookingInfo = CookingInfo(serving: serving, ingredients: ingredients, timeCooking: timeCooking)
        
        let macronutrientsInfo = MacronutrientsInfo(proteins: Int(recipeProfileEntity.proteins),
                                                    fats: Int(recipeProfileEntity.fats),
                                                    carbohydrates: Int(recipeProfileEntity.carbohydrates))
        
        let url = recipeProfileEntity.url ?? ""
        let categories = recipeProfileEntity.healthLabels ?? []
        let imageURL = recipeProfileEntity.image ?? ""
        let title = recipeProfileEntity.title ?? ""
        
        self.init(macronutrientsInfo: macronutrientsInfo, totalCalories: totalCalories, cookingInfo: cookingInfo, title: title, imageURL: imageURL, categories: categories, isFavorite: true, url: url)
    }
    
    init() {
        self.init(macronutrientsInfo: MacronutrientsInfo(proteins: 0, fats: 0, carbohydrates: 0), totalCalories: 0, cookingInfo: CookingInfo(serving: 0, ingredients: [], timeCooking: 0), title: "", imageURL: "", categories: [], isFavorite: false, url: "")
    }
    
    private func getMacronutrientsInfo(from recipe: Recipe) -> MacronutrientsInfo {
        let macronutrients: [Macronutrient?] = recipe.digest.map { digest in
           switch digest.label {
           case .carbs: return Macronutrient(type: .carbohydrates, quantity: Int(digest.total))
           case .fat:  return Macronutrient(type: .fats, quantity: Int(digest.total))
           case .protein:    return Macronutrient(type: .proteins, quantity: Int(digest.total))
           default: return nil
           }
        }
         return MacronutrientsInfo(from: macronutrients)
    }
}
