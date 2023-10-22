//
//  ImageLoader.swift
//  RecipeSearch
//
//  Created by user on 13.10.2023.
//

import UIKit

class ImageLoader {
    static func loadImage(from urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { completion(.failure(.customError(error.localizedDescription))) }
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                print("Invalid response") //ref.
                return
            }
            if let errorResponse = NetworkErrorHelper.handlerStatusCode(httpUrlResponse.statusCode) {
                completion(.failure(errorResponse)) }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure(.decodingError))
                return
            }
            DispatchQueue.main.async { completion(.success(image)) }
        }.resume()
    }
}
