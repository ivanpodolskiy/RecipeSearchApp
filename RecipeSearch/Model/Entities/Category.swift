//
//  Category.swift
//  RecipeSearch
//
//  Created by user on 14.06.2023.
//


struct Category {
    let diet: [String]
    let allergies: [String]
    
    var count: Int {
        get {
            return 2
        }
        set {}
    }
    
    func getName(_ section: Int) -> String {
        switch section {
        case 0:
            return "diet"
        case 1:
            return "allergies"
        default:
            return " "
        }
    }
    
    func getList(_ section: Int) -> [String] {
        print (section)
        switch section {
        case 0:
            return self.diet
        case 1:
            return self.allergies
        default:
            print("[]")
            return []
        }

    }
}
