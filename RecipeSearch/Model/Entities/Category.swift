//
//  Category.swift
//  RecipeSearch
//
//  Created by user on 14.06.2023.
//


//Возможно здесь нужно использовать класс а не структуру
// вместо массива нужно использовать перечисление


/*
Другой варинат это использовать еще одно структуру под занчение
 Например
 
 struct ValueCategory:
 name: String
 select: Bool

*/

struct ValueCategory {
    //Нужна обертка над именем и над селктом
 let name: String
private var select: Bool
    
   mutating func selectiong() {
        self.select = !select
    }
    
    init(name: String) {
        self.name = name
        self.select = false
    }
    
    
}


struct Category {
    typealias dietNmae = ValueCategory
    typealias allergiesName =  ValueCategory
    
    private let diet: [dietNmae]
    private let allergies: [allergiesName]
    
    init(dietValue: [ValueCategory], allergiesValue: [ValueCategory]) {
        self.diet = dietValue
        self.allergies = allergiesValue
    }
    
    subscript(section: Int) -> [ValueCategory]? {
        get {
            switch section {
            case 0:
                return self.diet
                
            case 1:
                return self.allergies
            default:
                return nil
            }
        }
        
    }
 

    
    var count: Int {
        get {
            return 2
        }
        set {}
    }
    
    func getName(_ section: Int) -> String {
        switch section {
        case 0:
            return "dietNmae"
        case 1:
            return "allergies"
        default:
            return " "
        }
    }
    
    
    func getList(_ section: Int) -> [ValueCategory] {
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
