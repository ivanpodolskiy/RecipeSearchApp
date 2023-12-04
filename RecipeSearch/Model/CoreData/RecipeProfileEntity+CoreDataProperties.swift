//
//  RecipeProfileEntity+CoreDataProperties.swift
//  RecipeSearch
//
//  Created by user on 29.11.2023.
//
//

import Foundation
import CoreData


extension RecipeProfileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeProfileEntity> {
        return NSFetchRequest<RecipeProfileEntity>(entityName: "RecipeProfileEntity")
    }

    @NSManaged public var healthLabels: [String]?
    @NSManaged public var image: String?
    @NSManaged public var ingredients: [String]?
    @NSManaged public var serving: Int64
    @NSManaged public var title: String?
    @NSManaged public var totalCalories: Int64
    @NSManaged public var url: String?
    @NSManaged public var recipesSectionEntity: RecipesSectionEntity?

}

extension RecipeProfileEntity : Identifiable {

}
