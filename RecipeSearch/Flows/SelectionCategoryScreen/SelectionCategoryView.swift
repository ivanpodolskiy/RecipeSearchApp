//
//  SelectionCategoryView.swift
//  RecipeSearch
//
//  Created by user on 06.06.2023.
//

import UIKit

enum Selected {
    case newCategory(String)
    case oldCategory(String)
}

class SelectionCategoryView: UIViewController {
    //MARK: - Properties
    private var category: [String]?
    
    public var completion: ((Selected) -> Void)?
    
    
    init(category: [String]?) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = getButtons(category)
        setActionsInButtons()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scrollView.reloadInputViews()
        scrollView.refreshControl?.beginRefreshing()
    }
    
    //MARK: - Outlets
    private  let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .basic
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let scrollView: UIScrollView  = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let newCategoryButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.setTitle("Create New", for: .normal)
        button.layer.cornerRadius = 19
        button.titleLabel?.textColor = .white
        return button
    }()
    
    private  var buttons:  [UIButton]?
    
    private  func setButton(title: String, tag: Int) -> UIButton{
        let button = UIButton()
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 19
        button.titleLabel?.textColor = .white
        return button
    }
    
    private func runAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Create category", message: "Type name for new category", preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .default) {   action in
            let textField = alertController.textFields![0]
            self.completion?(Selected.newCategory(textField.text!))
            textField.text = nil
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true)
        })
        
        alertController.addTextField { textField in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Name of a new category"
            textField.clearButtonMode = .whileEditing
        }
        alertController.addAction(createAction)
        alertController.addAction(cancel)
        return alertController
    }
    
    //MARK: - Functions
    private  func getButtons(_ category: [String]?) -> [UIButton]? {
        guard let category = category else { return nil }
        var buttons: [UIButton] = []
        var tag = 0
        for title in category {
            let button = setButton(title: title, tag: tag)
            buttons.append(button)
            tag += 1
        }
        return buttons
    }
    
    private func setActionsInButtons() {
        newCategoryButton.addTarget(self, action: #selector(presentAlert(sender: )), for: .touchUpInside)
        guard let buttons = buttons else { return }
        buttons.forEach { button in button.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchUpInside) }
    }
    
    private func setScrollHeight() {
        guard let buttons = buttons else { return }
        let heightForScroll = view.bounds.size.height +  (newCategoryButton.frame.height * CGFloat( buttons.count / 2) + 30)
        scrollView.contentSize.height =  heightForScroll
    }
    
    //MARK: - Actions
    @objc func tapButton(sender: UIButton) {
        guard let categoryName = sender.titleLabel?.text else { return }
        completion?(Selected.oldCategory(categoryName))
        dismiss(animated: true)
    }
    
    @objc func presentAlert(sender: UIButton) {
        present(runAlert(), animated: true)
    }
    
    //MARK: - Setup Constraints
    private func setupLayout() {
        setScrollHeight()
        view.addSubview(backgroundView)
        backgroundView.addSubview(scrollView)
        scrollView.addSubview(newCategoryButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            newCategoryButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 35),
            newCategoryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            newCategoryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            newCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        guard let buttons = buttons else { return }
        buttons.forEach({ button in
            scrollView.addSubview(button)
            if button.tag == 0 {
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: newCategoryButton.bottomAnchor, constant: 35),
                    button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
                    button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
                    button.heightAnchor.constraint(equalToConstant: 60) ])
            }
            else if button.tag == buttons.count - 1 {
                let LastIndex =  button.tag - 1
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: buttons[LastIndex].bottomAnchor, constant: 35),
                    button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
                    button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
                    button.heightAnchor.constraint(equalToConstant: 60),
                    button.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor) ])
            }
            else {
                let LastIndex =  button.tag - 1
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: buttons[LastIndex].bottomAnchor, constant: 35),
                    button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
                    button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
                    button.heightAnchor.constraint(equalToConstant: 60) ])
            }
        })
    }
}
