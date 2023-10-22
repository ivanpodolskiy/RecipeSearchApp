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
//ref.
class CategoryManager {
    private var type: CategoryType = .diet
    private var dietValues: [CategoryValueProtocol] = [CategoryValue(title: "balanced", category: .diet), CategoryValue(title: "high-fiber",  category: .diet), CategoryValue(title: "keto-friendly", category: .health), CategoryValue(title: "kosher", category: .health), CategoryValue(title: "low-fat", category: .diet), CategoryValue(title: "high-protein", category: .diet), CategoryValue(title: "low-carb", category: .diet), CategoryValue(title: "low-sodium", category: .diet), CategoryValue(title: "low-sugar", category: .health), CategoryValue(title: "pescatarian", category: .health), CategoryValue(title: "red-meat-free", category: .health), CategoryValue(title: "vegan", category: .health), CategoryValue(title: "vegetarian", category: .health) ]
    private var allergyValues: [CategoryValueProtocol] = [CategoryValue(title: "alcohol-free",  category: .health), CategoryValue(title: "celery-free", category: .health), CategoryValue(title: "crustacean-free", category: .health), CategoryValue(title: "dairy-free", category: .health),  CategoryValue(title: "egg-free",  category: .health), CategoryValue(title: "fish-free", category: .health), CategoryValue(title: "soy-free", category: .health), CategoryValue(title: "shellfish-free", category: .health), CategoryValue(title: "peanut-free", category: .health), CategoryValue(title: "mustard-free", category: .health)]
}

extension CategoryManager: CategoryManagerProtocol {
    //MARK: - убрать в CategoryStatusUpdater
    func changeStatus(_ selectedValueIndex: Int) -> [CategoryValueProtocol] {
        switch type {
        case .diet: dietValues[selectedValueIndex].selectValue()
            return dietValues
        case .health: allergyValues[selectedValueIndex].selectValue()
            return  allergyValues
                     }
    }
    //MARK: - убрать в CattegoryDataProvider
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
    //MARK: - убрать в CategoryFilter
    func getActiveValues() -> [CategoryValueProtocol]? {
        var filteredValues = [CategoryValue]()
        guard let sumValues = dietValues + allergyValues as? [CategoryValue] else { return nil}
        for value in sumValues {
            if value.getStatus() == true {filteredValues.append(value)}
        }
//        for value in sumValues { if value.getStatus() == true { filteredValues.append(value)} }
        return filteredValues
    }
    //MARK: - убрать в CategoryStatusClearer
    func setOriginalStatus() {
        func setStatusFalse(type: inout [CategoryValueProtocol]) {
            for i in 0..<type.count { type[i].setOriginalStatus() }
        }
        setStatusFalse(type: &dietValues)
        setStatusFalse(type: &allergyValues)
    }
}
