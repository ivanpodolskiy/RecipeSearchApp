//
//  RecipeSearchService.swift
//  RecipeSearch
//
//  Created by user on 11.05.2023.
//
import Foundation
final class RecipeSreachService {
    private var currentTask: URLSessionTask?

    func cancelPreviousRequests() {
          currentTask?.cancel()
      }
    
    public func searchRecipe(search text: String, completion: @escaping ([RecipeProfile]?) -> ()) {
        var urlComponents = URLComponents(string: "https://api.edamam.com/api/recipes/v2")!
        let params = ["type": "any", "app_id": "71021edf", "app_key": "389c0530b12807d2bd5033fb2694567c","q":"\(text)", "Accept-Language": "en"]
        urlComponents.queryItems = params.map({ name, value in URLQueryItem(name: name, value: value) })
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        
        let currentTask = session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else  { return }
            let decoder = JSONDecoder()
            do {
                let items =  try decoder.decode(Result.self, from: data)
                guard items.count != 0 else { return completion(nil)  }
                print ("items.count \(items.count)     items.hits.count \( items.hits.count)")

                
             
                var result: [RecipeProfile] = []
                for item in items.hits {
                    guard let recipe =  item.recipe else { return }
                    let countIngredient = recipe.ingredients?.count ?? 0
                    let calories = Int(recipe.calories ?? 0)
                    let infromation = RecipeInformation(healthlabels: recipe.healthLabels, listIngredients: recipe.ingredientLines)
                    let finalRecipeProfile = RecipeProfile(title: recipe.label,
                                                           image: recipe.image,
                                                           calories: calories,
                                                           countIngredients: countIngredient,
                                                           recipeInfromation: infromation,
                                                           url: recipe.url)
                    
                    result.append(finalRecipeProfile)
                    
                }
                print ("result count \(result.count)")
                completion(result)
                
            }
            catch {
                print ("catch \(error)")
            }
        }
        currentTask.resume()
    }
}
