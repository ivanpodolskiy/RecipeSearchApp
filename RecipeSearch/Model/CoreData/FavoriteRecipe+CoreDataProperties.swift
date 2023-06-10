//
//  FavoriteRecipe+CoreDataProperties.swift
//  RecipeSearch
//
//  Created by user on 10.06.2023.
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
    @NSManaged public var list: FavoriteList?

}

extension FavoriteRecipe : Identifiable {

}
