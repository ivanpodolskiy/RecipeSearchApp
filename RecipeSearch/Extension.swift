//
//  Extension.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

import Foundation
import UIKit
//Must do rename!

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

extension UIColor {
    static var basic: UIColor {
        return UIColor(red: 29/255.0, green: 80/255.0, blue: 210/255.0, alpha: 1.0)
    }
}
