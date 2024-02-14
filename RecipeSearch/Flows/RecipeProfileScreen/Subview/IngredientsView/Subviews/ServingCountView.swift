//
//  ServingCountView.swift
//  RecipeSearch
//
//  Created by user on 07.02.2024.
//

import UIKit

class ServingCountView: UIView {
    private let contextColor = UIColor(red: 84 / 255, green: 166 / 255, blue: 122 / 255, alpha: 1.0)
    func setServing(_ count: Int) {
        let symbol = String(count) + " "
        let updatedtext = servingCountLabel.text?.insertSymbolBeforeWord(insert: symbol)
        servingCountLabel.text = updatedtext
    }
    
    private lazy var servingCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "serving"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let cornerRadii = CGSize(width: 7.0, height: 7.0)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: cornerRadii)
        context.setFillColor(contextColor.cgColor)
        context.addPath(path.cgPath)
        context.fillPath()
        context.strokePath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        addSubview(servingCountLabel)
        activateLayoutConstraint()
    }
    
    private func activateLayoutConstraint() {
        NSLayoutConstraint.activate([
            servingCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            servingCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            servingCountLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            servingCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        ])
    }
}
