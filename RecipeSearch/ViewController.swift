//
//  ViewController.swift
//  RecipeSearch
//
//  Created by user on 28.04.2023.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Networking.getRecipe()
        // Do any additional setup after loading the view.
    }



}

class Networking {
    static func getRecipe() {
        var url = URLComponents(string: "https://api.edamam.com/api/recipes/v2")!
        
        let params = ["type":"public", "app_id":"71021edf", "beta":"true","app_key":"389c0530b12807d2bd5033fb2694567c", "q":"chicken", "ingr": "2", "excluded":"FOOD", "Accept-Language": "en"]
        url.queryItems =  params.map { name, value in
           URLQueryItem(name: name, value: value)
        }
        
        var urlRequest = URLRequest(url: url.url!)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) { data, respones, error in
            guard data != nil else {
                print ("data")
                return
            }
            
            if let error = error {
                print (error.localizedDescription)
            } else {
                print ("something")
                print(data?.description)
                let json = try? JSONSerialization.jsonObject(with: data!) as? [String: Any]
                print (json)
//                let jsonRes = try? (JSONSerialization.data(withJSONObject: data!, options: [])) as? [String: Any]
//                print(jsonRes)
            }
        }.resume()
    }
}
