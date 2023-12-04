//
//  SelectionMenuVC.swift
//  RecipeSearch
//
//  Created by user on 06.06.2023.
//

import UIKit

enum Selected {
    case newSection(String)
    case oldSection(String)
    case cancel
}
extension Selected: Equatable {
    static func == (lhs: Selected, rhs: Selected) -> Bool {
        switch (lhs, rhs) {
        case (.newSection(_), .newSection(_)):
            return true
        case (.oldSection(_), .oldSection(_)):
            return true
        case (.cancel, .cancel):
            return true
        default:
            return false
        }
    }
}
class SelectionMenuVC: UIViewController {
    private var titles: [String]?
    public var completion: ((Selected) -> Void)?
    private let alertUtility = AlertUtility()
    
    init(titles: [String]?) {
        self.titles = titles
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = getButtons(with: titles)
        setActions()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scrollView.reloadInputViews()
        scrollView.refreshControl?.beginRefreshing()
    }
    
    //MARK: - Outlets
    private var buttons:  [UIButton]?
    private let backgroundView: UIView = {
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
    
    private let newSelectButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.setTitle("Create New", for: .normal)
        button.layer.cornerRadius = 19
        button.titleLabel?.textColor = .white
        return button
    }()
        
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
    @objc func handleTextFieldTextChanged(sender: UITextField) {
        if let alertController = presentedViewController as? UIAlertController, let text = sender.text{
            if let actionAlert = alertController.actions.first {
                actionAlert.isEnabled = !text.isEmpty
            }
        }
    }
    private func runAlert() -> UIAlertController {
        let alertController = alertUtility.textInputAlert(title: "Creating section", message: "Type name for new section", placeholder: "", target: self, handleTextFieldTextChanged: #selector(handleTextFieldTextChanged)) { [weak self] text in
            guard let self = self, let text = text else { return }
            self.completion?(Selected.newSection(text))
            self.dismiss(animated: true)
        } cancelCompletion: { [weak self] in
            guard let self = self else { return }
            self.completion?(Selected.cancel)
          self.dismiss(animated: true)
        }
        return alertController
    }
    
    //MARK: - Functions
    private  func getButtons(with titles: [String]?) -> [UIButton]? {
        guard let titles = titles else { return nil }
        var buttons: [UIButton] = []
        var number = 0
        for title in titles {
            let button = setButton(title: title, tag: number)
            buttons.append(button)
            number += 1
        }
        return buttons
    }
    private func setActions() {
        newSelectButton.addTarget(self, action: #selector(presentAlert(sender: )), for: .touchUpInside)
        guard let buttons = buttons else { return }
        buttons.forEach { button in button.addTarget(self, action: #selector(self.tapAction(sender:)), for: .touchUpInside) }
    }
    private func setScrollHeight() {
           guard let buttons = buttons else { return }
           let heightForScroll = view.bounds.size.height +  (newSelectButton.frame.height * CGFloat( buttons.count / 2) + 30)
           scrollView.contentSize.height =  heightForScroll
       }
    //MARK: - Actions
    @objc func tapAction(sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        completion?(Selected.oldSection(title))
        dismiss(animated: true)
    }
    @objc func presentAlert(sender: UIButton) {
        present(runAlert(), animated: true)
    }
    //MARK: - Setup Layouts
    private func setupLayout() {
        setScrollHeight()
        view.addSubview(backgroundView)
        backgroundView.addSubview(scrollView)
        scrollView.addSubview(newSelectButton)
        
        NSLayoutConstraint.activate([
                   backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
                   backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
                   backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
                   backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                   
                   scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                   scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
                   scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
                   scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                   
                   newSelectButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 35),
                   newSelectButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
                   newSelectButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
                   newSelectButton.heightAnchor.constraint(equalToConstant: 60)
               ])
        guard let buttons = buttons else { return }
                buttons.forEach({ button in
                    scrollView.addSubview(button)
                    if button.tag == 0 {
                        NSLayoutConstraint.activate([
                            button.topAnchor.constraint(equalTo: newSelectButton.bottomAnchor, constant: 35),
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
