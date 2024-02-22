//
//  MacronutrientsView.swift
//  RecipeSearch
//
//  Created by user on 07.02.2024.
//

import UIKit

class MacronutrientsInfoView: UIView  {
    private let proteinsView: MacronutrientView = {
        let view = MacronutrientView(type: .proteins)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let fatsView: MacronutrientView = {
        let view = MacronutrientView(type: .fats)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let carbohydratesView: MacronutrientView = {
        let view = MacronutrientView(type: .carbohydrates)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(proteinsView)
        addSubview(fatsView)
        addSubview(carbohydratesView)
        
        NSLayoutConstraint.activate([
            proteinsView.topAnchor.constraint(equalTo: topAnchor),
            proteinsView.leftAnchor.constraint(equalTo: leftAnchor),
            proteinsView.rightAnchor.constraint(equalTo: rightAnchor),
            
            fatsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            fatsView.leftAnchor.constraint(equalTo: leftAnchor),
            fatsView.rightAnchor.constraint(equalTo: rightAnchor),
            
            carbohydratesView.leftAnchor.constraint(equalTo: leftAnchor),
            carbohydratesView.rightAnchor.constraint(equalTo: rightAnchor),
            carbohydratesView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension MacronutrientsInfoView {
    func setInfo(_ info: MacronutrientsInfo) {
        proteinsView.setTextToGramsLabel(with: info.proteins.quantity)
        fatsView.setTextToGramsLabel(with: info.fats.quantity)
        carbohydratesView.setTextToGramsLabel(with: info.carbohydrates.quantity)
    }
}
