//
//  Alert.swift
//  RecipeSearch
//
//  Created by user on 24.12.2023.
//

import UIKit


class CustomAlert: UIView {
    init(title: String, message: String) {
        super.init(frame: CGRect.zero)
        titleLabel.text = title
        messageLabel.text = message
        settingMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviews()
        setupSubviewsConstraints()
        setupMainStackViewConstraints()
    }
    
    fileprivate func settingMainView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        layer.masksToBounds = true
        layer.cornerRadius = 12
    }
    
    fileprivate func dismiss() {
        guard let window = UIWindow.current else { return }
        let alert = getAlert(from: window.subviews)
        alert.removeFromSuperview()
    }
    
    fileprivate func getAlert(from subviews: [UIView]) -> UIView  {
        var alertIndex = subviews.count - 1
        let stringType = "\(type(of: subviews[alertIndex]))"
        if stringType == "_UIEditMenuContainerView" {
            alertIndex -= 1
        }
      return  subviews[alertIndex]
    }
    
    fileprivate let titlesContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    fileprivate let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = .systemBackground
        stackView.spacing = 5
        return stackView
    }()
    
    fileprivate func setupSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(titlesContainerView)
        titlesContainerView.addSubview(titleLabel)
        titlesContainerView.addSubview(messageLabel)
    }
    
    fileprivate func setupSubviewsConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titlesContainerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: titlesContainerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: titlesContainerView.trailingAnchor, constant: -8 ),
            titleLabel.heightAnchor.constraint(equalToConstant: 17),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            messageLabel.leadingAnchor.constraint(equalTo: titlesContainerView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: titlesContainerView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: titlesContainerView.bottomAnchor, constant: -3)
        ])
    }
    fileprivate func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
//MARK: - NotificationCustomAlert
class NotificationAlert: CustomAlert {
    override init(title: String, message: String) {
        super.init(title: title, message: message)
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupSubviews() {
        super.setupSubviews()
        mainStackView.addArrangedSubview(button)
    }
    private lazy var button: UIButton =  {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        button.setTitleColor(.selected, for: .normal)
        return button
    }()
    
    @objc func tapAction(_ sender: UIButton) {
    dismiss()
    }
}
class SolutionAlert: CustomAlert {
    var actionHandler: ((Any) -> Void)?
    var cancelHandler: (() -> Void)?
    
    init(title: String, message: String, actionHandler: ((Any) -> Void)? = nil, cancelHandler: (() -> Void)? = nil) {
        super.init(title: title, message: message)
        self.actionHandler = actionHandler
        self.cancelHandler = cancelHandler
        buttonsContainerView.actionButton.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
        buttonsContainerView.cancelButton.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var buttonsContainerView: ButtonsContainerView = {
        let view = ButtonsContainerView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc private func actionTap(_ sender: UIButton) {
        actionHandler?(())
        dismiss()
    }
    
    @objc private func cancelTap(_ sender: UIButton) {
        cancelHandler?()
        dismiss()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        mainStackView.addArrangedSubview(buttonsContainerView)
    }
}

class TextFieldAlert: CustomAlert  {
    private var errorText: String?
    private var actionHandler: ((Any) -> Void)?
    private var textСheckingHandler:  ((String) -> Bool)?
    private var cancelHandler: (() -> Void)?
    
    init(title: String, message: String, actionHandler:  ((Any) -> Void)?, cancelHandler:  (() -> Void)?, textСheckingHandler:  ((String) -> Bool)?, errorText: String? = nil) {
        super.init(title: title, message: message)
        self.actionHandler = actionHandler
        self.cancelHandler = cancelHandler
        self.textСheckingHandler = textСheckingHandler
        self.errorText = errorText
        
        self.setTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var buttonsContainerView: ButtonsContainerView = {
        let view = ButtonsContainerView()
        view.isActionButtonEnabled(false)
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.keyboardAppearance = .alert
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.placeholder = "Type text"
        textField.textColor = .selected
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.red.cgColor
        return textField
    }()
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        mainStackView.addArrangedSubview(errorLabel)
        mainStackView.addArrangedSubview(textField)
        mainStackView.addArrangedSubview(buttonsContainerView)
    }

    private func setTargets() {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        buttonsContainerView.actionButton.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
        buttonsContainerView.cancelButton.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        errorLabel.text = ""
        isActionButtonEnabled(!text.isEmpty)
    }
    @objc private func actionTap(_ sender: UIButton) {
        guard let text = textField.text else { return }
        if textСheckingHandler!(text)  {
            actionHandler?(text)
            dismiss()
        } else {
            showError()
            isActionButtonEnabled(false)
        }
    }
    @objc private func cancelTap(_ sender: UIButton) {
        cancelHandler?()
        dismiss()
    }
    private func showError() {
        errorLabel.text = errorText
    }
    private func isActionButtonEnabled(_ isEnabled: Bool) {
        buttonsContainerView.isActionButtonEnabled(isEnabled)
    }
}
