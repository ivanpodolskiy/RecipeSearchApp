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
    func cancelPreviousRequests() { currentTask?.cancel() }
    func searchRecipes(selectedCategories categoryValues: [CategoryValueProtocol]?, with searchText: String,
                       completion: @escaping (Result<[RecipeProfileProtocol],NetworkError>) -> Void)  {
        guard let url =  getURL(categoryValues, searchText) else {
            completion(.failure(.badURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let urlConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: urlConfiguration)
        currentTask = session.dataTask(with: urlRequest){ data, response, error in
            print ("textInService \(searchText)")

            if let error = error {
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    completion(.failure(.notConnectedToInternet))
                } else {
                    completion(.failure(.customError(error.localizedDescription)))
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response") //ref.
                return
            }
            if let errorHttpResponse = NetworkErrorHelper.handlerStatusCode(httpResponse.statusCode) {
                completion(.failure(errorHttpResponse))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode(RecipesResult.self, from: data)
                guard items.count != 0 else {return completion(.failure(.dataError(.notitems))) }
                print ("items.count \(items.count)     items.hits.count \( items.hits.count)")
                var result: [RecipeProfile] = []
                for item in items.hits {
                    guard let recipe =  item.recipe else { return }
                    let totalCalories = Int(recipe.calories ?? 0)
                    let recipeProfile = RecipeProfile(title: recipe.label, image: recipe.image, totalCalories: totalCalories, url: recipe.url, serving: recipe.yield, healthLabels: recipe.healthLabels, ingredientLines: recipe.ingredientLines)
                    result.append(recipeProfile)
                }
                completion(.success(result))
            }
            catch {
                completion(.failure(.decodingError))
            }
        }
        currentTask?.resume()
    }
    
    private func getURL(_ categoryValues: [CategoryValueProtocol]?, _ text: String) -> URL? {
        var urlComponents = URLComponents(string: "https://api.edamam.com/api/recipes/v2")!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "type", value: "any"),
            URLQueryItem(name: "app_id", value: "71021edf"),
            URLQueryItem(name: "app_key", value: "389c0530b12807d2bd5033fb2694567c"),
            URLQueryItem(name: "q", value: text),
        ]
        if let values = categoryValues {
            values.forEach { value in
                queryItems.append(URLQueryItem(name: value.category.rawValue, value: value.title))
            }
        }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        return url
    }
}
