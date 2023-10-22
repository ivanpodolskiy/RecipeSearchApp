//
//  CoreDataError.swift
//  RecipeSearch
//
//  Created by user on 22.10.2023.
//

enum CoreDataError: Error {
    case saveError
    case fetchError
    case deletionError
    
    var localizedDescription: String {
        switch self  {
        case .saveError:
            return "Failed to save data to Core Data."
        case .fetchError:
            return "Failed to fetch data from Core Data."
        case .deletionError:
            return "Failed to delete data from Core Data."
        }
    }
}
