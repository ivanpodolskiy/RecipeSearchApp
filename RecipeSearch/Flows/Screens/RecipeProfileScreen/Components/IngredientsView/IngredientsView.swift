//
//  IngredientsView.swift
//  RecipeSearch
//
//  Created by user on 17.05.2023.
//

import UIKit

class IngredientsView: UIView {
    private let containerColor = UIColor(red: 222 / 255, green: 226 / 255, blue: 209 / 255, alpha: 1.0)
    private let titleText: String = "Ingredients List:"
    
    init(cookingInfo: CookingInfo) {
        super.init(frame: .zero)
        self.setDataAndsetupUI(ingredients: cookingInfo.ingredients, servingCount: cookingInfo.serving, timeCooking: cookingInfo.timeCooking)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .basic
        label.textAlignment = .left
        label.text = titleText
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = containerColor
        view.layer.cornerRadius = 12
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor(red: 123 / 255.0, green: 137 / 255.0, blue: 134 / 255.0, alpha: 1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    private lazy var timeCookingView: TimeCookingView = {
        let view = TimeCookingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    private lazy var countServingView: ServingCountView = {
        let view = ServingCountView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    
    private func setupUI(isShowingCookingTimeView: Bool) {
        addSubview(countServingView)
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(ingredientsLabel)
        activateLayoutConstraint(andForCookingTime: isShowingCookingTimeView)
    }
    
    private func activateLayoutConstraint(andForCookingTime: Bool) {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),

            ingredientsLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            ingredientsLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            ingredientsLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            ingredientsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            
            countServingView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            countServingView.heightAnchor.constraint(equalToConstant: 36),
        ])
        
        if andForCookingTime {
            NSLayoutConstraint.activate([
                countServingView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                countServingView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
          
        } else {
            insertSubview(timeCookingView, at: 1)
            NSLayoutConstraint.activate([
                countServingView.rightAnchor.constraint(equalTo: timeCookingView.leftAnchor, constant: 5),
                timeCookingView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
                timeCookingView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                timeCookingView.heightAnchor.constraint(equalToConstant: 40),
                timeCookingView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}

extension IngredientsView {
    private func setDataAndsetupUI(ingredients: [String], servingCount: Int, timeCooking: Int) {
        joinedAndSetText(ingredients: ingredients)
        countServingView.setServing(servingCount)
        
        timeCookingView.setTime(timeCooking)
        setupUI(isShowingCookingTimeView: timeCooking == 0)
    }
    
    private func joinedAndSetText(ingredients: [String]) {
        let bulletSymbol = "\u{2022} "
        let ingredientsString = ingredients.map {  text in
            return text.insertSymbolBeforeWord(insert: bulletSymbol)
        }.joined(separator: "\n")
        ingredientsLabel.text = ingredientsString
    }
}
