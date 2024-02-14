//
//  SelectionMenuViewController.swift
//  RecipeSearch
//
//  Created by user on 06.06.2023.
//

import UIKit

class SelectionPanelViewController: UIViewController {
    private let buttonHeight: CGFloat = 50
    private let stackViewSpacing: CGFloat = 20
    private let firstButtonTitle: String = "Create new section"

    private var presenter: SelectionMenuPresenterProtocol?
    
    func setPresenter(presenter: SelectionMenuPresenterProtocol) {
        self.presenter = presenter
    }
    
    private var buttonContainer:  [UIButton] = []
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .basic
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints  = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = self.stackViewSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAndInstallOutlets()
    }
    
    private func prepareAndInstallOutlets() {
        fillButtonContainer()
        addSubviewsAndSetupLayout()
    }
    
    private func fillButtonContainer() {
        let titles = fetchTitles()
        setupButtonsInContainer(with: titles)
    }
    
    private func fetchTitles() -> [String]? {
        let titles = presenter?.fetchSectionTitles()
        return titles ?? nil
    }
    
    private  func setupButtonsInContainer(with titles: [String]?) {
        //FirstButton
        addButtonToContainerWithAction(title: firstButtonTitle, backgroundColor: .selected) { button in
            button.addTarget(self, action: #selector(self.generativeAction(sender: )), for: .touchUpInside)
        }
        //NextButtons
        guard let titles = titles else { return}
        for title in titles {
            addButtonToContainerWithAction(title: title, backgroundColor: .orange) { button in
                button.addTarget(self, action: #selector(self.selectionAction), for: .touchUpInside)
            }
        }
    }
    
    private func addButtonToContainerWithAction(title: String, backgroundColor: UIColor? = nil, action: ((UIButton) -> Void)? = nil) {
        let button = getButton(title: title)
        if let backgroundColor = backgroundColor {
            button.backgroundColor = backgroundColor
        }
        buttonContainer.append(button)
        action?(button)
    }
    
    private  func getButton(title: String) -> UIButton{
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.numberOfLines = 1
        button.layer.cornerRadius = 19
        button.titleLabel?.textColor = .white
        return button
    }
    
    @objc func generativeAction(sender: UIButton) {
        presenter?.addNewSection()
    }
    
    @objc func selectionAction(sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        presenter?.selectExistingSection(title)
    }
    
    private func addSubviewsAndSetupLayout() {
        view.addSubview(backgroundViewContainer)
        scrollView.addSubview(stackView)
        backgroundViewContainer.addSubview(scrollView)
        addButtonsToStackView()
        activeLayoutConstraint()
    }
    
    private func addButtonsToStackView() {
        buttonContainer.forEach { button in
            stackView.addArrangedSubview(button)
        }
    }
    
    private func activeLayoutConstraint() {
        let horizontalConstant: CGFloat = 15
        let verticalConstant: CGFloat = 25
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: verticalConstant),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -verticalConstant),
            stackView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, constant: -verticalConstant * 2),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: horizontalConstant),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -horizontalConstant * 2),
            
            scrollView.topAnchor.constraint(equalTo: backgroundViewContainer.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: backgroundViewContainer.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundViewContainer.bottomAnchor),
            
            backgroundViewContainer.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
            backgroundViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundViewContainer.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        activeLayoutConstraintForButtons()
    }
    
    private func activeLayoutConstraintForButtons() {
        buttonContainer.forEach { button in
            button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        }
    }
}
extension SelectionPanelViewController: SelectionMenuDelegate {
    func dismiss() {
        dismiss(animated: true)
    }
}
