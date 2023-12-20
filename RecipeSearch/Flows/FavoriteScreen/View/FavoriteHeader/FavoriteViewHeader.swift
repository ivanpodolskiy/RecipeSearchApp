//
//  FavoriteViewHeader.swift
//  RecipeSearch
//
//  Created by user on 04.06.2023.
//

import UIKit

//MARK: - FavoriteViewHeader
class FavoriteViewHeader: UICollectionReusableView {
    var deleteActionHandler: (() -> Void)?
    var updatingTitleHandler: ((String) -> Void)?
    
    private var countRecipes: Int = 0  {
        didSet {
            itemsCountLabel.text = "count: \(countRecipes)"
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutConstraint()
        setHandlers()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        editingView.reloadInputViews()
        titleLabel.reloadInputViews()
    }
    private func setHandlers() {
        editingView.deleteActionHandler = { [weak self] in
            guard let self = self else { return }
            self.deleteActionHandler?()
        }
        editingView.editingActionHandler = { [weak self] isEditing in
            guard let self = self else { return}
            self.titleLabel.toggleTextViewMode()
        }
        titleLabel.updatingTextHandler = { [weak self] updatedText in
            guard let self = self else { return }
            self.updatingTitleHandler?(updatedText)
        }
    }
    //MARK: - Outlets
    private var editingView: SwitchableButtonDisplay = {
        let editingView = SwitchableButtonDisplay()
        editingView.translatesAutoresizingMaskIntoConstraints = false
        return editingView
    }()
    private  let titleLabel: EditableTextView  = {
        let titleLabel = EditableTextView()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    private let itemsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment  = .right
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .gray
        return label
    }()
    //MARK: - Setting layout
    private func setLayoutConstraint() {
        addSubview(editingView)
        addSubview(titleLabel)
        addSubview(itemsCountLabel)
        NSLayoutConstraint.activate([
            editingView.leftAnchor.constraint(equalTo: leftAnchor),
            editingView.topAnchor.constraint(equalTo: topAnchor),
            editingView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.leftAnchor.constraint(equalTo: editingView.rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.rightAnchor.constraint(equalTo: itemsCountLabel.leftAnchor, constant: -5),
            
            itemsCountLabel.rightAnchor.constraint(equalTo: rightAnchor),
            itemsCountLabel.topAnchor.constraint(equalTo: topAnchor),
            itemsCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
//MARK: - Extensions
extension FavoriteViewHeader {
    static var identifier: String { return String(describing: self) }
    func setSectionDesctiption(title: String, countItems: Int) {
        titleLabel.setText(title)
        countRecipes = countItems
    }
}
