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
            guard let self = self else { return }
            do {
                let data = try Data(contentsOf: url)
                 let image = UIImage(data: data)
                DispatchQueue.main.async {
                        self.image = image
                    }
            } catch {
                print ("Error")
            }
        }
    }
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let data = data, error == nil,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.image = image
            }
        }.resume()
    
    }
    
    func downloaded(link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return}
        downloaded(from: url, contentMode: mode)
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
