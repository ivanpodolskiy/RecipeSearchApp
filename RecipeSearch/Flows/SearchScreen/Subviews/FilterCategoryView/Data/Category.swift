//
//  Category.swift
//  RecipeSearch
//
//  Created by user on 15.09.2023.
//

enum CategoryType: String{
    case diet
    case health
}
protocol CategoryValueProtocol {
    var title: String { get }
    var type: CategoryType { get }
    
    mutating func setOriginalStatus()
    mutating   func selectValue()
    func getStatus() -> Bool
}

struct CategoryValue: CategoryValueProtocol {
    let title: String
    let type: CategoryType
    private(set) var status = false
    
    mutating func selectValue() {
        status.toggle()
    }
    mutating  func setOriginalStatus() {
        status = false
    }
    
    func getStatus() -> Bool {
        return status
    }
}
