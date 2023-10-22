//
//  FavoriteList+CoreDataProperties.swift
//  RecipeSearch
//
//  Created by user on 10.06.2023.
//
//

import Foundation
import CoreData


extension FavoriteList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteList> {
        return NSFetchRequest<FavoriteList>(entityName: "FavoriteList")
    }

    @NSManaged public var nameCategory: String?
    @NSManaged public var recipes: NSSet?

}

extension FavoriteList {

    @objc(addRecipesObject:)
    @NSManaged public func addToRecipes(_ value: FavoriteRecipe)

    @objc(removeRecipesObject:)
    @NSManaged public func removeFromRecipes(_ value: FavoriteRecipe)

    @objc(addRecipes:)
    @NSManaged public func addToRecipes(_ values: NSSet)

    @objc(removeRecipes:)
    @NSManaged public func removeFromRecipes(_ values: NSSet)
}

extension FavoriteList : Identifiable {

}
