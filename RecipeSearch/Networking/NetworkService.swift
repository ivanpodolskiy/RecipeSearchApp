//
//  NetworkService.swift
//  RecipeSearch
//
//  Created by user on 18.02.2024.
//

import Foundation

fileprivate enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkingProtocol {
    func sendRequest<T: Decodable>(form url: URL, decodingType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
    func cancel()
}

class NetworkService: NetworkingProtocol {
    private var currentTask: URLSessionTask?
    private var session: URLSession
    private var method = HTTPMethod.get
    
    func cancel() {
        currentTask?.cancel()
    }
    
    init() {
        let urlConfiguration = URLSessionConfiguration.default
        self.session = URLSession(configuration: urlConfiguration)
    }
    
    func sendRequest<T: Decodable>(form url: URL, decodingType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let urlRequest = getlRequest(url: url, method: HTTPMethod.get)
        
        currentTask = session.dataTask(with: urlRequest) {data, response, error in
            if let error = error {
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    completion(.failure(.notConnectedToInternet))
                } else {
                    completion(.failure(.customError(error.localizedDescription)))
                }
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if let errorHttpResponse = NetworkErrorHelper.handlerStatusCode(httpResponse.statusCode) {
                completion(.failure(errorHttpResponse))
            }
            
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode(T.self, from: data)
                completion(.success(items))
            }
            catch {
                completion(.failure(.decodingError))
            }
        }
        currentTask?.resume()
    }
    
    private func getlRequest(url: URL, method: HTTPMethod) -> URLRequest{
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
