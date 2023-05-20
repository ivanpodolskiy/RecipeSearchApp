//
//  RecipeInformation.swift
//  RecipeSearch
//
//  Created by user on 20.05.2023.
//

enum TypeOfInforamtion {
    case ingredients
    case healthList
}
struct RecipeInformation {
    private var healthLabels: [String]
    private var listIngredients: [String]
    
    
    init(healthlabels: [String], listIngredients: [String]) {
        self.healthLabels = healthlabels
        self.listIngredients = listIngredients
    }
    func getInfromation(type: TypeOfInforamtion ) -> String {
        switch type {
        case .ingredients:
            return listIngredients.toString(separator: " ")
        case .healthList:
            return healthLabels.toString(separator: " ")
        }
    }
}
