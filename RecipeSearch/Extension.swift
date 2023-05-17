//
//  Extension.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

import Foundation
import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}
extension UIColor {
    static var basic: UIColor {
        return UIColor(named: "basic")!
    }
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
