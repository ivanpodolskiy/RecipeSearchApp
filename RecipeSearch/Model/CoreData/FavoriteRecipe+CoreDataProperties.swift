//
//  FavoriteRecipe+CoreDataProperties.swift
//  RecipeSearch
//
//  Created by user on 20.10.2023.
//
//

import Foundation
import CoreData


extension FavoriteRecipe {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRecipe> {
        return NSFetchRequest<FavoriteRecipe>(entityName: "FavoriteRecipe")
    }
    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var totalCalories: Int64
    @NSManaged public var healthLabels: [String]?
    @NSManaged public var serving: Int64
    @NSManaged public var ingredients: [String]?
    @NSManaged public var list: FavoriteList?
}

extension FavoriteRecipe : Identifiable {
}
