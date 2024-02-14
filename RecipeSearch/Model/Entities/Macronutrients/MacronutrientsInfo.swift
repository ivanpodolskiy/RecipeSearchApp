//
//  MacronutrientsInfo.swift
//  RecipeSearch
//
//  Created by user on 06.02.2024.
//


protocol MacronutrientsInfoProtocol {
    var proteins: MacronutrientProtocol {get }
    var fats: MacronutrientProtocol { get }
    var carbohydrates: MacronutrientProtocol { get }
    
    func percentage(for type: MacronutrientType) -> Float
}

struct MacronutrientsInfo {
    var proteins: MacronutrientProtocol
    var fats: MacronutrientProtocol
    var carbohydrates: MacronutrientProtocol
    
    private var amount: Int {
        get{ return proteins.quantity + fats.quantity + carbohydrates.quantity }
    }
    
    private init() {
        proteins = Macronutrient(type: .proteins, quantity: 0)
        fats = Macronutrient(type: .proteins, quantity: 0)
        carbohydrates = Macronutrient(type: .carbohydrates, quantity: 0)
    }
    
    init(from macronutrients: [Macronutrient?]) {
        self.init()
        macronutrients.forEach { macronutrient in
            guard let macronutrient = macronutrient else  { return }
            switch macronutrient.type  {
            case .proteins: proteins = macronutrient
            case .fats: fats = macronutrient
            case .carbohydrates: carbohydrates = macronutrient
            }
        }
    }
    
    init(proteins: Int, fats: Int, carbohydrates: Int){
        self.proteins = Macronutrient(type: .proteins, quantity: proteins)
        self.fats = Macronutrient(type: .fats, quantity: fats)
        self.carbohydrates = Macronutrient(type: .carbohydrates, quantity: carbohydrates)
    }
    
    
//    mutating func set(_ macronutrient: Macronutrient) {
//        switch macronutrient.type {
//        case .proteins : proteins.quantity = macronutrient.quantity
//        case .fats : self.fats.quantity = macronutrient.quantity
//        case .carbohydrates : self.carbohydrates.quantity = macronutrient.quantity
//        }
//        
//    }
    
    func percentage(for type: MacronutrientType) -> Float {
        var numerator: Float
        
        switch type {
        case .proteins:         numerator = Float(proteins.quantity)
        case .fats:             numerator = Float(fats.quantity)
        case .carbohydrates:    numerator = Float(carbohydrates.quantity)
        }
        return getPercent(get: numerator, from: Float(amount))
    }
    
    private func getPercent(get numerator: Float, from max: Float) -> Float {
        return (numerator / max) * 100.0
    }
}
