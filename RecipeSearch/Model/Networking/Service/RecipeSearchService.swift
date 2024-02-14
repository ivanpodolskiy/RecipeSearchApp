//
//  RecipeSearchService.swift
//  RecipeSearch
//
//  Created by user on 11.05.2023.
//
import Foundation

protocol RecipeSearchServiceProtocol {
    func searchRecipes(selectedCategories categoryValues: [CategoryValueProtocol]?, with text: String, completion: @escaping (Result<[RecipeProfileProtocol], NetworkError> ) -> Void)
    func cancelPreviousRequests()
}
//MARK: - RecipeSreachService
final class RecipeSreachService: RecipeSearchServiceProtocol {
    private var currentTask: URLSessionTask?
    private var urlBuilder = URLBuilder()
    
    func cancelPreviousRequests() {
        currentTask?.cancel()
    }
    func searchRecipes(selectedCategories categoryValues: [CategoryValueProtocol]?, with searchText: String,
                       completion: @escaping (Result<[RecipeProfileProtocol],NetworkError>) -> Void)  {
        
        guard let url =  urlBuilder.buildURL(with: searchText, categoryValues: categoryValues) else {
            completion(.failure(.badURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let urlConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: urlConfiguration)
     
        
        currentTask = session.dataTask(with: urlRequest){ data, response, error in
            if let error = error {
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    completion(.failure(.notConnectedToInternet))
                } else {
                    completion(.failure(.customError(error.localizedDescription)))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response") //ref.
                return
            }
            
            if let errorHttpResponse = NetworkErrorHelper.handlerStatusCode(httpResponse.statusCode) {
                completion(.failure(errorHttpResponse))
            }
            
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode(RecipesResult.self, from: data)
                
                guard !items.hits.isEmpty else {
                    completion(.failure(.dataError(.notitems)))
                    return
                }
                
                let result: [RecipeProfile] = items.hits.compactMap({ item in
                    guard let recipe = item.recipe else { return nil }
                    return RecipeProfile(recipeResult: recipe)
                })
                completion(.success(result))
            }
            catch {
                completion(.failure(.decodingError)) //ref.
            }
        }
        currentTask?.resume()
    }
}

