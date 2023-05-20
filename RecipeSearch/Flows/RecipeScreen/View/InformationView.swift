//
//  InformationView.swift
//  RecipeSearch
//
//  Created by user on 18.05.2023.
//
import UIKit

class InformationView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private(set) lazy var buttonFavorite: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.layer.opacity = 0.5
        return button
    }()
    
    private(set) lazy var linkLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Instructions"
        return label
    }()

    private func setupLayout() {
        backgroundColor = .basic
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 19
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.30
        layer.shadowOffset = CGSize(width: 2, height: 1)
        layer.shadowColor = UIColor.black.cgColor
        
        addSubview(countCaloriesLabel)
        addSubview(countDailyValueLabel)
        addSubview(countServingsLabel)
        addSubview(buttonFavorite)
        addSubview(linkLabel)
        addSubview(namesDataLabel)
        
        NSLayoutConstraint.activate([
    
            countCaloriesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            countCaloriesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            countCaloriesLabel.rightAnchor.constraint(equalTo: countDailyValueLabel.leftAnchor, constant: -25),
            countCaloriesLabel.heightAnchor.constraint(equalToConstant: 30),
        
            
            countDailyValueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            countDailyValueLabel.topAnchor.constraint(equalTo: countCaloriesLabel.topAnchor),
            countDailyValueLabel.heightAnchor.constraint(equalToConstant: 30),
            
            countServingsLabel.topAnchor.constraint(equalTo: countCaloriesLabel.topAnchor),
            countServingsLabel.leftAnchor.constraint(equalTo: countDailyValueLabel.rightAnchor, constant: 25),
            countServingsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            countServingsLabel.heightAnchor.constraint(equalToConstant: 30),
            
            namesDataLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            namesDataLabel.topAnchor.constraint(equalTo: countCaloriesLabel.bottomAnchor, constant: 2),

            buttonFavorite.topAnchor.constraint(equalTo: namesDataLabel.bottomAnchor, constant: 25),
            buttonFavorite.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            buttonFavorite.widthAnchor.constraint(equalToConstant: 40),
            buttonFavorite.heightAnchor.constraint(equalToConstant: 40),

            linkLabel.topAnchor.constraint(equalTo: namesDataLabel.bottomAnchor, constant: 35),
            linkLabel.leftAnchor.constraint(equalTo:  buttonFavorite.rightAnchor, constant: 15),
            linkLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
        ])
    }
    
}
