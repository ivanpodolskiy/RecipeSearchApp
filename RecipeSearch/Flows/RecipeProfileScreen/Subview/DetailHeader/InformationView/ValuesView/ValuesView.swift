//
//  numberView.swift
//  RecipeSearch
//
//  Created by user on 31.05.2023.
//

import UIKit

class ValuesView: UIView {
    private(set) lazy var caloriesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "kcal"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private(set) lazy var servingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "serving"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private(set) lazy var countCaloriesLabel: UILabel =  {
        let label = UILabel()
        label.textAlignment = .center
        label.baselineAdjustment = .alignBaselines
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        label.text = "0"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private(set) lazy var countServingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.baselineAdjustment = .alignBaselines
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    func setData(countServings: Int, countCalories: Int) {
        countServingsLabel.text = String(countServings)
        countCaloriesLabel.text = String(countCalories)
    }
    override func layoutSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(countCaloriesLabel)
        addSubview(countServingsLabel)
        addSubview(caloriesLabel)
        addSubview(servingLabel)
        NSLayoutConstraint.activate([
            countCaloriesLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            countCaloriesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            caloriesLabel.leftAnchor.constraint(equalTo: countCaloriesLabel.rightAnchor, constant: 1),
            caloriesLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            servingLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            servingLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            countServingsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            countServingsLabel.rightAnchor.constraint(equalTo: servingLabel.leftAnchor, constant: -1)
        ])
    }
}


