//
//  displayView.swift
//  RecipeSearch
//
//  Created by user on 07.02.2024.
//

import UIKit

class MacronutrientsDisplayView: UIView {
    private var drawLine: Bool = false
    private var macronutrientsInfo: MacronutrientsInfo?

    private lazy var  macronutrientsInfoView =  MacronutrientsInfoView()
    private lazy var  macronutrientProgressView =  MacronutrientProgressView()
    
    private(set) lazy var favoriteButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowColor = UIColor.black.cgColor
        
        button.tintColor = .white
        return button
    }()
        
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        activateLayoutConstraint()
        drawLine(macronutrientInfo: macronutrientsInfo)
    }
    
    private func addSubviews() {
        macronutrientsInfoView.translatesAutoresizingMaskIntoConstraints = false
        macronutrientProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(favoriteButton)
        addSubview(macronutrientsInfoView)
        addSubview(macronutrientProgressView)
    }
    
    private func activateLayoutConstraint() {
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: topAnchor),
            favoriteButton.leftAnchor.constraint(equalTo: leftAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 55),
            favoriteButton.heightAnchor.constraint(equalToConstant: 55),
            
            macronutrientsInfoView.topAnchor.constraint(equalTo: topAnchor),
            macronutrientsInfoView.leftAnchor.constraint(equalTo: favoriteButton.rightAnchor, constant: 5),
            macronutrientsInfoView.rightAnchor.constraint(equalTo: rightAnchor),
            macronutrientsInfoView.bottomAnchor.constraint(equalTo: favoriteButton.bottomAnchor),
            
            macronutrientProgressView.topAnchor.constraint(equalTo: macronutrientsInfoView.bottomAnchor, constant: 10),
            macronutrientProgressView.heightAnchor.constraint(equalToConstant: 13),
            macronutrientProgressView.leftAnchor.constraint(equalTo: leftAnchor),
            macronutrientProgressView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    private func drawLine(macronutrientInfo: MacronutrientsInfo?) {
        guard let macronutrientInfo = macronutrientInfo else { return }
        if !drawLine {
            let proteins_p = CGFloat(macronutrientInfo.percentage(for: .proteins))
            let fats_p =  CGFloat(macronutrientInfo.percentage(for: .fats))
            let carbohydrates_p = CGFloat(macronutrientInfo.percentage(for: .carbohydrates))
            macronutrientProgressView.draw(proteinsPercent: proteins_p, fatsPercent: fats_p, carbohydratesPercent: carbohydrates_p)
            drawLine = true
        }
    }
}

extension MacronutrientsDisplayView {
    func loadInfoToView(_ info: MacronutrientsInfo) {
        macronutrientsInfo = info
        macronutrientsInfoView.setInfo(info)
    }
    
    func updateButtonColor(_ color: UIColor) {
        favoriteButton.tintColor = color
    }
}
