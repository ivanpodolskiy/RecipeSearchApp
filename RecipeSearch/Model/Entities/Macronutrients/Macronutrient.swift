//
//  Mac.swift
//  RecipeSearch
//
//  Created by user on 13.02.2024.
//


protocol MacronutrientProtocol {
    var type: MacronutrientType { get }
    var quantity: Int { get }
}

enum MacronutrientType: Int {
    case proteins
    case fats
    case carbohydrates
}

struct Macronutrient: MacronutrientProtocol {
    let type: MacronutrientType
    let quantity: Int
}
