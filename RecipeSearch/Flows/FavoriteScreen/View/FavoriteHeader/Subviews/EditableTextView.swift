//
//  EditableTextView.swift
//  RecipeSearch
//
//  Created by user on 17.12.2023.
//

import UIKit

class EditableTextView: UIView {
    var updatingTextHandler: ((String) -> (Void))?
    private var isTextFieldMode: Bool = false {
       didSet {
           switchTextLableMode(isTextFieldMode)
       }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(textLabel)
        addSubview(textField)
        textLabel.frame = bounds
        textField.frame = bounds
    }
    override func reloadInputViews() {
        super.reloadInputViews()
        isTextFieldMode = false
    }
    //MARK: - Outlets
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment  = .left
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.systemGray
        return label
    }()
    private lazy var textField: UITextField = {
       let textField = UITextField()
        textField.isHidden = true
        textField.textAlignment  = .left
        textField.borderStyle = .roundedRect
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.textColor = .systemBlue
        return textField
    }()
    
    private func switchTextLableMode(_ isTextFieldMode: Bool) {
        textLabel.isHidden = isTextFieldMode
        textField.isHidden = !isTextFieldMode
        
        if isTextFieldMode {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            guard let updatedText = textField.text, updatedText != textLabel.text else { return }
                textLabel.text = updatedText
                updatingTextHandler?(updatedText)
        }
    }
}
//MARK: - Extensions
extension EditableTextView {
    func setText(_ text: String) {
       textLabel.text = text
       textField.text = text
   }
    func toggleTextViewMode() {
        isTextFieldMode.toggle()
    }
}
