//
//  CategoryService.swift
//  RecipeSearch
//
//  Created by user on 15.09.2023.
//

protocol CategoryManagerProtocol {
    func getCategoryData(categoryType: CategoryType?, callBack:  ([CategoryValueProtocol], _ type: CategoryType) -> Void)
    func getActiveValues() -> [CategoryValueProtocol]?
    func changeStatus(_ selectedValueIndex: Int) -> [CategoryValueProtocol]
    func setOriginalStatus()
}

class CategoryManager {
    private var type: CategoryType = .diet
    
    private var dietValues: [CategoryValueProtocol] = [CategoryValue(title: "balanced", type: .diet), CategoryValue(title: "high-fiber",  type: .diet), CategoryValue(title: "keto-friendly", type: .health), CategoryValue(title: "kosher", type: .health), CategoryValue(title: "low-fat", type: .diet), CategoryValue(title: "high-protein", type: .diet), CategoryValue(title: "low-carb", type: .diet), CategoryValue(title: "low-sodium", type: .diet), CategoryValue(title: "low-sugar", type: .health), CategoryValue(title: "pescatarian", type: .health), CategoryValue(title: "red-meat-free", type: .health), CategoryValue(title: "vegan", type: .health), CategoryValue(title: "vegetarian", type: .health) ]
    
    private var allergyValues: [CategoryValueProtocol] = [CategoryValue(title: "alcohol-free",  type: .health), CategoryValue(title: "celery-free", type: .health), CategoryValue(title: "crustacean-free", type: .health), CategoryValue(title: "dairy-free", type: .health),  CategoryValue(title: "egg-free",  type: .health), CategoryValue(title: "fish-free", type: .health), CategoryValue(title: "soy-free", type: .health), CategoryValue(title: "shellfish-free", type: .health), CategoryValue(title: "peanut-free", type: .health), CategoryValue(title: "mustard-free", type: .health)]
}

extension CategoryManager: CategoryManagerProtocol {
    func changeStatus(_ selectedValueIndex: Int) -> [CategoryValueProtocol] {
        switch type {
        case .diet: dietValues[selectedValueIndex].selectValue()
            return dietValues
        case .health: allergyValues[selectedValueIndex].selectValue()
            return  allergyValues
                     }
    }

    func getCategoryData(categoryType: CategoryType?, callBack: ([CategoryValueProtocol], CategoryType) -> Void) {
        switch categoryType {
        case .diet:
            self.type = .diet
            callBack(dietValues, type)
        case .health :
            self.type = .health
            callBack(allergyValues, type)
        case nil:
            if type == .diet {
                callBack(dietValues, type)
            } else {
                callBack(allergyValues, type)
            }
        }
    }

    func getActiveValues() -> [CategoryValueProtocol]? {
        var filteredValues = [CategoryValue]()
        guard let sumValues = dietValues + allergyValues as? [CategoryValue] else { return nil}
        for value in sumValues {
            if value.getStatus() == true {filteredValues.append(value)}
        }
        return filteredValues
    }

    func setOriginalStatus() {
        func setStatusFalse(type: inout [CategoryValueProtocol]) {
            for i in 0..<type.count { type[i].setOriginalStatus() }
        }
        setStatusFalse(type: &dietValues)
        setStatusFalse(type: &allergyValues)
    }
}
