//
//  MacronutrientProgressView.swift
//  RecipeSearch
//
//  Created by user on 07.02.2024.
//

import UIKit

class MacronutrientProgressView: UIView {
    private var firstPoint: CGFloat?
    private var midPoint: CGFloat?
    private var lastPont: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.cornerRadius = 6
        clipsToBounds = true
        backgroundColor = .purple
    }
   
    func draw(proteinsPercent: CGFloat, fatsPercent: CGFloat, carbohydratesPercent: CGFloat) {
        layoutIfNeeded()
        guard  bounds.width > 0.0 else { return }
        
        let oneProcentWidth = bounds.width / 100
        firstPoint = oneProcentWidth * proteinsPercent
        midPoint = oneProcentWidth * fatsPercent + firstPoint!
        lastPont = oneProcentWidth * carbohydratesPercent + midPoint!
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let firstPoint = firstPoint,
              let midPoint = midPoint,
              let lastPont = lastPont else { return }
        
        drawSegment(atX: 0, toX: firstPoint, withColor: .green)
        drawSegment(atX: firstPoint, toX: midPoint, withColor: .systemYellow)
        drawSegment(atX: midPoint, toX: lastPont, withColor: .systemRed)
    }
    
    private func drawSegment(atX: CGFloat, toX: CGFloat, withColor: UIColor) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: atX, y: bounds.height / 2))
        path.addLine(to: CGPoint(x: toX, y: bounds.height / 2))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = withColor.cgColor
        shapeLayer.lineWidth = bounds.height
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
    }
}
