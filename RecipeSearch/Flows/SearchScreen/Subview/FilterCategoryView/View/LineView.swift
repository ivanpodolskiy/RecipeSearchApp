//
//  LineView.swift
//  RecipeSearch
//
//  Created by user on 15.09.2023.
//

import UIKit

class LineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var lineStartPosition: CategoryType  = .diet{ //ref.
        didSet { setNeedsDisplay() }
    }
    private let path:  UIBezierPath = {
        let path = UIBezierPath()
        path.lineWidth = 2.0
        path.lineJoinStyle = .round
        return path
    }()
    override  func draw(_ rect: CGRect) {
        path.removeAllPoints()
        UIColor.selected.setStroke()
        super.draw(rect)
        switch lineStartPosition {
        case .diet:
            path.move(to: CGPoint(x: 2, y: bounds.height / 2))
            path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height / 2))
        case .health:
            path.move(to: CGPoint(x: bounds.width / 2, y: bounds.height / 2))
            path.addLine(to: CGPoint(x: bounds.width - 2, y: bounds.height / 2))
        }
        path.stroke()
    }
}

