//
//  numberView.swift
//  RecipeSearch
//
//  Created by user on 31.05.2023.
//

import UIKit

class ValuesView: UIView {
    //MARK: - Outlets
    private(set) lazy var namesDataLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.text = "Calories  Daily value  Serving"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) lazy var countCaloriesLabel: UILabel =  {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 25)
        label.text = "83"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var countDailyValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 25)
        label.text = "4%"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var countServingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 25)
        label.text = "2"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - View Functions
    override func layoutSubviews() {
        addSubview(countCaloriesLabel)
        addSubview(countDailyValueLabel)
        addSubview(countServingsLabel)
        addSubview(namesDataLabel)

        NSLayoutConstraint.activate([
            countCaloriesLabel.topAnchor.constraint(equalTo: topAnchor),
            countCaloriesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            
            countDailyValueLabel.topAnchor.constraint(equalTo: topAnchor),
            countDailyValueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            countServingsLabel.topAnchor.constraint(equalTo: topAnchor),
            countServingsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            namesDataLabel.topAnchor.constraint(equalTo: countCaloriesLabel.bottomAnchor),
            namesDataLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            namesDataLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])        
    }
}


