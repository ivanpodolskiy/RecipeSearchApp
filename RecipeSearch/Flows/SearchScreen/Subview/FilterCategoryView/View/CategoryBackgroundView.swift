//
//  CategoryBackgroundView.swift
//  RecipeSearch
//
//  Created by user on 15.09.2023.
//

import UIKit

class CategoryBackgroundView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        let foldHeight: CGFloat = 20
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height - foldHeight))
        path.addQuadCurve(to: CGPoint(x: bounds.width - foldHeight, y: bounds.height), controlPoint: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: foldHeight, y: bounds.height))
        path.addQuadCurve(to: CGPoint(x: 0, y: bounds.height - foldHeight), controlPoint: CGPoint(x: 0, y: bounds.height))
        path.close()
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .basic
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
