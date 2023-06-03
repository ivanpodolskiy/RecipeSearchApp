//
//  FavoriteRecipes+CoreDataProperties.swift
//  RecipeSearch
//
//  Created by user on 27.05.2023.
//
//

import Foundation
import CoreData


extension FavoriteRecipes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRecipes> {
        return NSFetchRequest<FavoriteRecipes>(entityName: "FavoriteRecipes")
    }

    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var calories: Int64
    @NSManaged public var countUngredients: Int64
    @NSManaged public var url: String?
}

extension FavoriteRecipes : Identifiable {

}
