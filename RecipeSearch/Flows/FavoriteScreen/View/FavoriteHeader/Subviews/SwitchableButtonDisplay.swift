//
//  SwitchableButtonDisplay.swift
//  RecipeSearch
//
//  Created by user on 17.12.2023.
//

import UIKit

class SwitchableButtonDisplay: UIView {
    var deleteActionHandler: (() -> Void)?
    var editingActionHandler: ((Bool) -> Void)?
    
    private var widthAnchorSelf: NSLayoutConstraint!
    private var widthAnchorSelfTest: NSLayoutConstraint!
    private var receiveSwitchButtonConstrains: [NSLayoutConstraint] = []
    private var deleteButtonConstrains: [NSLayoutConstraint] = []
    
    private var isEditing: Bool = false {
        didSet {
            changeEditingMode(isEditing)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupTargets()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reloadInputViews() {
        super.reloadInputViews()
        isEditing = false
    }

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let receiveSwitchButton: UIButton = {
        let  button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash.circle"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
   
    private func setupLayout() {
        widthAnchorSelf =  widthAnchor.constraint(equalToConstant: 25)
        widthAnchorSelfTest = widthAnchor.constraint(equalToConstant: 50)
        addSubview(containerView)
        containerView.addSubview(receiveSwitchButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            widthAnchorSelf
        ])
        receiveSwitchButtonConstrains = [
            receiveSwitchButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            receiveSwitchButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            receiveSwitchButton.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            receiveSwitchButton.widthAnchor.constraint(equalToConstant: 25),
        ]
        deleteButtonConstrains = [
            deleteButton.leftAnchor.constraint(equalTo: receiveSwitchButton.rightAnchor),
            deleteButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
        ]
        NSLayoutConstraint.activate(receiveSwitchButtonConstrains)
    }
  
    private func changeEditingMode(_ isEiting: Bool) {
        let imageString = isEditing ? "checkmark.circle": "pencil"
        let buttonColor = isEiting ? UIColor.systemBlue : UIColor.systemGray
        receiveSwitchButton.setImage(UIImage(systemName: imageString), for: .normal)
        receiveSwitchButton.tintColor = buttonColor
        isEiting ? activateLayoutDeleteButton() : backDefaultLayout()
        editingActionHandler?(isEiting)
    }
    
    private func activateLayoutDeleteButton() {
        NSLayoutConstraint.deactivate([widthAnchorSelf, widthAnchorSelfTest])
        NSLayoutConstraint.activate([widthAnchorSelfTest])
        containerView.addSubview(deleteButton)
        NSLayoutConstraint.activate(deleteButtonConstrains)
    }
    
    private func backDefaultLayout() {
       NSLayoutConstraint.deactivate([widthAnchorSelfTest, widthAnchorSelf])
       NSLayoutConstraint.deactivate(deleteButtonConstrains)
       deleteButton.removeFromSuperview()
       NSLayoutConstraint.activate([widthAnchorSelf])
   }
    
    private func setupTargets() {
        deleteButton.addTarget(self, action: #selector(handleTapRemove), for: .touchUpInside)
        receiveSwitchButton.addTarget(self, action: #selector(handleTapEditing), for: .touchUpInside)
    }
    
    @objc func handleTapEditing(_ sender: UIButton) {
        runEditingControl() }
    
    private func runEditingControl() {
        isEditing.toggle()
    }
    
    @objc func handleTapRemove(_ sender: UIButton) {
        deleteActionHandler?()
    }
}
