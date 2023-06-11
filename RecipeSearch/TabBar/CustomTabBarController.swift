//
//  CustomTabBarController.swift
//  RecipeSearch
//
//  Created by user on 22.05.2023.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundImage = nil
        tabBar.backgroundColor = UIColor.white.withAlphaComponent(0)
        viewControllers = [setupVC(.search), setupVC(.favorite)]
        setupTabBarLayout()
    }
    
    private func setupVC(_ tbItem: CustomTabBarItem) -> UIViewController {
        let vc = tbItem.viewController
        vc.tabBarItem.title = tbItem.title
        vc.tabBarItem.image = tbItem.icon
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.white.withAlphaComponent(0.4)], for: .normal)
        vc.tabBarItem.selectedImage = tbItem.selectedIcon
        return vc
    }
    
    private func setupTabBarLayout() {
        let positionOnX: CGFloat = 15
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        let roundLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY, width: width, height: height), cornerRadius: height / 2)
        roundLayer.path = bezierPath.cgPath
        roundLayer.fillColor = UIColor.basic.cgColor
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width 
        tabBar.itemPositioning = .automatic
        
        print (" width \(width) height \(height) ")
    }
}
