//
//  Extension.swift
//  RecipeSearch
//
//  Created by user on 10.05.2023.
//

import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

extension UIColor {
    static var basic: UIColor {
        return UIColor(named: "basic")!
    }
    static var selected: UIColor { //ref.
        return UIColor(red: 161 / 255.0, green: 225 / 255.0, blue: 136 / 255.0, alpha: 1.0)
    }
    static var notSelected: UIColor {
        return UIColor.white
    }
}

extension String {
    func insertSymbolBeforeWord(insert symbol: String) -> String {
        return symbol + self
    }
}

extension [String] {
    func toString(separator: String) -> String {
        let stringText = self.joined(separator: separator)
        return stringText
    }
}

extension UITabBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 71
        return sizeThatFits
    }
}

extension CGFloat {
    static func itemWidth(for width: CGFloat, spacing: CGFloat, itemsInRow: CGFloat) -> CGFloat {
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        return finalWidth - 2
    }
}
