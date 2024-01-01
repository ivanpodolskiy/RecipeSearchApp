//
//  WindowService.swift
//  RecipeSearch
//
//  Created by user on 01.01.2024.
//
import UIKit

protocol WindowServiceProtocol {
    var currentWindow: UIWindow? { get }
    func addViewToWindow(_ view: UIView)
    func removeViewFromWindow(_ view: UIView)
}

protocol WindowServiceSubviewsKeeper {
    func getSubviews() -> [UIView]?
    
}

protocol WindowServiceRemover {
    func removeLastSubview()
}
                                            
class WindowService: WindowServiceProtocol {
    var currentWindow: UIWindow? {
        UIWindow.current
    }
    
    func addViewToWindow(_ view: UIView) {
        guard let window = currentWindow else { return }
        window.addSubview(view)
    }
    
    func removeViewFromWindow(_ view: UIView) {
        guard let window = currentWindow else { return }
        if view.isDescendant(of: window) {
            view.removeFromSuperview()
        }
        
    }
}

extension WindowService: WindowServiceSubviewsKeeper {
    func getSubviews() -> [UIView]? {
        return currentWindow?.subviews
    }
}

extension WindowService: WindowServiceRemover {
    func removeLastSubview() {
        guard let subiews = getSubviews(), let lastSubiview = subiews.last else { return }
        removeViewFromWindow(lastSubiview)
    }
}
