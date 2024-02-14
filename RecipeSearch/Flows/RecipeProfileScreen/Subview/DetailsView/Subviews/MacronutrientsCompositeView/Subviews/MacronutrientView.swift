//
//  MacronutrientView.swift
//  RecipeSearch
//
//  Created by user on 07.02.2024.
//

import UIKit

class MacronutrientView: UIView {
    init(type: MacronutrientType) {
        super.init(frame: .zero)
        self.setupTitleAndCircle(use: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let gramsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 14)
        label.text = ""
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.text = ""
        return label
    }()
    
    private let viewCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupTitleAndCircle(use type: MacronutrientType) {
        switch type {
        case .proteins: setData(title: "PROT", color: .green)
        case .fats: setData(title: "FAT", color: .yellow)
        case .carbohydrates: setData(title: "CARB ", color: .red)
        }
    }
    
    private func setData(title: String, color: UIColor) {
        titleLabel.text = title
        viewCircle.backgroundColor = color
    }
    
    func setTextToGramsLabel(with grams: Int)  {
        let unit = "g"
        self.gramsLabel.text = String(grams) + unit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(viewCircle)
        addSubview(titleLabel)
        addSubview(gramsLabel)
        
        NSLayoutConstraint.activate([
            viewCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            viewCircle.leftAnchor.constraint(equalTo: leftAnchor),
            viewCircle.widthAnchor.constraint(equalToConstant: 12),
            viewCircle.heightAnchor.constraint(equalToConstant: 12),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: viewCircle.rightAnchor, constant: 3),
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
            
            gramsLabel.topAnchor.constraint(equalTo: topAnchor),
            gramsLabel.leftAnchor.constraint(equalTo: centerXAnchor, constant: 5),
            gramsLabel.rightAnchor.constraint(equalTo: rightAnchor),
            gramsLabel.heightAnchor.constraint(equalToConstant: 15),
            gramsLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
