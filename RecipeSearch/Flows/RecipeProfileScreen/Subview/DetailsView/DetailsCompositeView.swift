//
//  DetailsCompositeView .swift
//  RecipeSearch
//
//  Created by user on 17.05.2023.
//

import UIKit

class DetailsCompositeView: UIViewController {
    private let transition = PanelTransition()
    private var presenter: DetailsPresenterProtocol!
    
    func setPreseter(_ presenter: DetailsPresenterProtocol) {
        self.presenter = presenter
    }
    
    override func loadView() {
        super.loadView()
        presenter.loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        activateLayoutConstraint()
        presenter.loadImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setActions()
    }
    
    private lazy var macronutrientsDisplayView = MacronutrientsDisplayView()
     
    private lazy var recipeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.basic
        return label
    }()
    private lazy var containerDisplayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 2, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor

        view.layer.cornerRadius = 12
        view.backgroundColor = .basic
        return view
    }()
    private lazy var caloriesView: CaloriesView = {
        let caloriesView = CaloriesView()
        caloriesView.setTextColor(color: .basic)
        caloriesView.translatesAutoresizingMaskIntoConstraints = false
        return caloriesView
    }()
    private lazy var recipeImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "placeholder")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = UIColor(red: 243 / 255.0, green: 245 / 255.0, blue: 251 / 255.0, alpha: 1.0)
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()
    private lazy var viewForImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.isHidden = false
        return indicator
    }()
    private lazy var instructionView: InstructionView = {
        let view = InstructionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
   
    private func setActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showWebScreen))
        instructionView.addGestureRecognizer(tapGesture)
        macronutrientsDisplayView.favoriteButton.addTarget(self, action: #selector(switchFavoriteStatus(sender: )), for: .touchUpInside)
    }
    
    @objc private func showWebScreen(sender: UIButton) {
        presenter.pushWebViewController()
    }
    @objc private func switchFavoriteStatus(sender: UIButton) {
        presenter.switchFavoriteStatus(nil, atIndex: nil)
      }
    
    private func addSubviews() {
        macronutrientsDisplayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recipeTitle)
        view.addSubview(viewForImage)
        viewForImage.addSubview(recipeImageView)
        recipeImageView.addSubview(activityIndicator)
        view.addSubview(caloriesView)
        view.addSubview(instructionView)
        view.addSubview(containerDisplayView)
        containerDisplayView.addSubview(macronutrientsDisplayView)
    }
    
    private func activateLayoutConstraint() {
        NSLayoutConstraint.activate([
            recipeTitle.topAnchor.constraint(equalTo: view.topAnchor),
            recipeTitle.leftAnchor.constraint(equalTo: view.leftAnchor),
            recipeTitle.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            recipeImageView.topAnchor.constraint(equalTo: recipeTitle.bottomAnchor, constant: 5),
            recipeImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            recipeImageView.widthAnchor.constraint(equalToConstant: 180),
            recipeImageView.heightAnchor.constraint(equalToConstant: 185),
            recipeImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: recipeImageView.centerXAnchor, constant: 0.0),
            activityIndicator.centerYAnchor.constraint(equalTo: recipeImageView.centerYAnchor, constant: 0.0),
            
            caloriesView.bottomAnchor.constraint(equalTo: containerDisplayView.topAnchor, constant: -2),
            caloriesView.leftAnchor.constraint(equalTo: containerDisplayView.leftAnchor, constant: 5),
            caloriesView.rightAnchor.constraint(equalTo: containerDisplayView.rightAnchor, constant: -5),
        ])
        activateDisplayConstraint()
    }
    private func activateDisplayConstraint() {
        NSLayoutConstraint.activate([
            containerDisplayView.centerYAnchor.constraint(equalTo: recipeImageView.centerYAnchor),
            containerDisplayView.leftAnchor.constraint(equalTo: recipeImageView.rightAnchor, constant: 8),
            containerDisplayView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerDisplayView.heightAnchor.constraint(equalToConstant: 95),
            
            macronutrientsDisplayView.topAnchor.constraint(equalTo: containerDisplayView.topAnchor, constant: 5),
            macronutrientsDisplayView.leftAnchor.constraint(equalTo: containerDisplayView.leftAnchor, constant: 10),
            macronutrientsDisplayView.rightAnchor.constraint(equalTo: containerDisplayView.rightAnchor, constant: -10),
            macronutrientsDisplayView.bottomAnchor.constraint(equalTo:  containerDisplayView.bottomAnchor)
        ])
        activateInstructionConstraint()
    }
    private func activateInstructionConstraint() {
        NSLayoutConstraint.activate([
            instructionView.topAnchor.constraint(equalTo: containerDisplayView.bottomAnchor, constant: -10),
            instructionView.leftAnchor.constraint(equalTo: containerDisplayView.leftAnchor),
            instructionView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension DetailsCompositeView: DetailsPresenterDelegate {
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func updateFavoriteStatus(_ isFavorite: Bool) {
        let statusColor: UIColor = isFavorite ? .yellow : .white
        macronutrientsDisplayView.updateButtonColor(statusColor)
    }
    
    func presentError(_ userFriendlyDescription: String) {
        print(userFriendlyDescription)
    }
 
    func presentCustomSheet(_ viewController: UIViewController) {
        viewController.transitioningDelegate = transition
        viewController.modalPresentationStyle = .custom
        DispatchQueue.main.async { self.present(viewController, animated: true) }
    }
    
    func sendDataToController(calories: Int,macronutrientsInfo: MacronutrientsInfo, favoriteStatus statusFavorite: Bool, title: String) {
        recipeTitle.text = title
        let color: UIColor = statusFavorite ? .yellow : .white
        
        macronutrientsDisplayView.updateButtonColor(color)
        macronutrientsDisplayView.loadInfoToView(macronutrientsInfo)
        caloriesView.setText(with: calories)
    }
    
    func loadImage(_ image: UIImage) {
        recipeImageView.image = image
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
