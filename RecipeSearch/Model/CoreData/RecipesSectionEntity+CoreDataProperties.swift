//
//  RecipesSectionEntity+CoreDataProperties.swift
//  RecipeSearch
//
//  Created by user on 29.11.2023.
//
//

import Foundation
import CoreData


extension RecipesSectionEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipesSectionEntity> {
        return NSFetchRequest<RecipesSectionEntity>(entityName: "RecipesSectionEntity")
    }

    @NSManaged public var nameSection: String?
    @NSManaged public var recipeProfileEntity: NSSet?
}

extension RecipesSectionEntity {

    @objc(addRecipeProfileEntityObject:)
    @NSManaged public func addToRecipeProfileEntity(_ value: RecipeProfileEntity)

    @objc(removeRecipeProfileEntityObject:)
    @NSManaged public func removeFromRecipeProfileEntity(_ value: RecipeProfileEntity)

    @objc(addRecipeProfileEntity:)
    @NSManaged public func addToRecipeProfileEntity(_ values: NSSet)

    @objc(removeRecipeProfileEntity:)
    @NSManaged public func removeFromRecipeProfileEntity(_ values: NSSet)
}

extension RecipesSectionEntity : Identifiable {

}
