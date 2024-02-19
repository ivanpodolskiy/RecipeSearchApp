//
//  RecipeSearchService.swift
//  RecipeSearch
//
//  Created by user on 11.05.2023.
//
import Foundation

protocol RecipeSearchServiceProtocol {
    func cancelPreviousRequests()
    func searchRecipes(selectedCategories categoryValues: [CategoryValueProtocol]?, with searchText: String, completion: @escaping (Result<[RecipeProfileProtocol],NetworkError>) -> Void)
}
//MARK: - RecipeSreachService
final class RecipeSreachService: RecipeSearchServiceProtocol {
    private var urlBuilder = URLBuilder()
    private var networking: NetworkingProtocol
    
    init(networking: NetworkingProtocol ) {
        self.networking = networking
    }
    
    func cancelPreviousRequests() {
        networking.cancel()
    }
    
    func searchRecipes(selectedCategories categoryValues: [CategoryValueProtocol]?, with searchText: String, completion: @escaping (Result<[RecipeProfileProtocol],NetworkError>) -> Void) {
        guard let url = getURL(from: searchText, use: categoryValues) else {
            (completion(.failure(.badURL)))
            return
        }
        
        networking.sendRequest(form: url, decodingType: RecipesResult.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let items) :
                guard !items.hits.isEmpty else {
                    completion(.failure(.dataError(.notitems)))
                    return
                }
                
                guard let recipes = decode(items: items) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(recipes))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getURL(from searchText: String, use categoryValues: [CategoryValueProtocol]?) -> URL? {
        guard let url =  urlBuilder.buildURL(with: searchText, categoryValues: categoryValues) else {
            return nil
        }
        return url
    }
    
    private func decode<T: Decodable>(items: T) -> [RecipeProfile]? {
        guard let items = items as? RecipesResult else {
            return nil
        }
        
        let result: [RecipeProfile] = items.hits.compactMap({ item in
            guard let recipe = item.recipe else { return nil }
            return RecipeProfile(recipeResult: recipe)
        })
        
        return result
    }
}

