//
//  InstructionView.swift
//  RecipeSearch
//
//  Created by user on 08.02.2024.
//

import UIKit

class InstructionView: UIView {
    private let contextColor = UIColor(red: 216 / 255, green: 177 / 255, blue: 255 / 255, alpha: 1.0)
    
    private let safariImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "safari")
        imageView.tintColor = .white

        imageView.layer.shadowRadius = 2
        imageView.layer.shadowOpacity = 0.4
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView.layer.shadowColor = UIColor.black.cgColor

        return imageView
    }()
    
    private let linkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Instruction"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.3
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowColor = UIColor.black.cgColor
        
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let cornerRadii = CGSize(width: 10.0, height: 10.0)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: cornerRadii)
        context.setFillColor(contextColor.cgColor)
        context.addPath(path.cgPath)
        context.fillPath()
        
        context.strokePath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        setSubviews()
        activateLayoutConstraint()
    }
    
    private func setSubviews() {
        addSubview(linkLabel)
        addSubview(safariImageView)
    }
    
    private func activateLayoutConstraint() {
        NSLayoutConstraint.activate([
            safariImageView.centerYAnchor.constraint(equalTo: linkLabel.centerYAnchor),
            safariImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            safariImageView.heightAnchor.constraint(equalToConstant: 25),
            safariImageView.widthAnchor.constraint(equalToConstant: 25),
            
            linkLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            linkLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            linkLabel.leftAnchor.constraint(equalTo: safariImageView.rightAnchor, constant: 2),
            linkLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        ])
    }
}
