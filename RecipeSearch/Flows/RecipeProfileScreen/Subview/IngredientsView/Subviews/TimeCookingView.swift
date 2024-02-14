//
//  TimeCookingView.swift
//  RecipeSearch
//
//  Created by user on 07.02.2024.
//

import UIKit

class TimeCookingView: UIView {
    private let contextColor = UIColor(red: 178 / 255, green: 204 / 255, blue: 98 / 255, alpha: 1.0)

    func setTime(_ time: Int) {
        if time != 0 {
            timeLabel.text = "\(time) min"
        }
    }
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "timer")
        imageView.tintColor = .white
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let cornerRadii = CGSize(width: 7, height: 7.0)
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
        addSubview(timeLabel)
        addSubview(imageView)
    }
    
    private func activateLayoutConstraint() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            timeLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 2),
            timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        ])
    }
}
