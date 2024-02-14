//
//  WindowService.swift
//  RecipeSearch
//
//  Created by user on 01.01.2024.
//
import UIKit

protocol WindowServiceSubviewsKeeper {
    func getSubviews() -> [UIView]?
}
protocol WindowServiceRemover {
    func removeViewFromWindow(_ view: UIView)
    func removeLastSubview()
}

protocol WindowServiceProtocol: WindowServiceRemover, WindowServiceSubviewsKeeper  {
    var currentWindow: UIWindow? { get }
    func addViewToWindow(_ view: UIView)
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
        guard let window = currentWindow, view.isDescendant(of: window)else  { return }
        view.removeFromSuperview()
    }
}

extension WindowService: WindowServiceSubviewsKeeper {
    func getSubviews() -> [UIView]? {
        return currentWindow?.subviews
    }
}

extension WindowService: WindowServiceRemover {
    func removeLastSubview() {
        guard let subviews = getSubviews(), let lastSubiview = subviews.last else { return }
        removeViewFromWindow(lastSubiview)
    }
}
