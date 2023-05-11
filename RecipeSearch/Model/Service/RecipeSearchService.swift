//
//  RecipeSearchService.swift
//  RecipeSearch
//
//  Created by user on 11.05.2023.
//

import Foundation
final class RecipeSreachService {
    
    public func searchRecipe(search text: String, completion: @escaping ([RecipeProfile]) -> ()) {
        var urlComponents = URLComponents(string: "https://api.edamam.com/api/recipes/v2")!
        let params = ["type": "public", "app_id": "71021edf", "app_key": "389c0530b12807d2bd5033fb2694567c","q":"\(text)", "Accept-Language": "en"]
        
        urlComponents.queryItems = params.map({ name, value in
            URLQueryItem(name: name, value: value)
        })
        
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var recipe: [RecipeProfile] = []

        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let jsonData = data {
                let decoder = JSONDecoder()
    
                do {
                    let items =  try decoder.decode(Welcome.self, from: jsonData)
                    let hits = items.hits
                    for i in hits {
                        recipe.append(RecipeProfile(title: i.recipe.label, description: i.recipe.uri, imageNew: i.recipe.image))
                    }
                    completion(recipe)
                }
                catch {
                    print ("catch \(error)")
                }
            }
        }
        task.resume()
    }
}
