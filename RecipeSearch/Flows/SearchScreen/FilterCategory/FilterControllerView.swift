//
//  FilterControllerView.swift
//  RecipeSearch
//
//  Created by user on 15.09.2023.
//

import UIKit

class FilterViewController: UIViewController {
    private var categoryValues: [CategoryValueProtocol]?
    private var presenter: FilterPresenterProtocol!
    private var dietConstraint: NSLayoutConstraint?
    private var allergyConstraint: NSLayoutConstraint?
    
    func setPresenter(_ presenter: FilterPresenterProtocol) { self.presenter = presenter }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        setupCategoryTypeBoard()
        setupCategoryValueCollection()
        presenter.displaySecletedCategory(.none)
        for button in [dietsButton, allergiesButton] { button.addTarget(self, action: #selector(tapOnCategoryType), for: .touchUpInside) }
    }
    //MARK: - Outlets
    private let backgroundViewForCollection = BackgroundView()
    private let lineView =  LineView()
    
    private let collectionVFilterValues: UICollectionView = {
        let layoutCollectionView = UICollectionViewFlowLayout()
        layoutCollectionView.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutCollectionView)
        collectionView.backgroundColor = UIColor.basic
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let dietsButton: UIButton =  {
        let button = UIButton()
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Diet", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.notSelected, for: .normal)
        return button
    }()
    private let allergiesButton: UIButton =  {
        let button = UIButton()
        button.tag = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Allergies", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.notSelected, for: .normal)
        return button
    }()
    //MARK: - Actions
    @objc func tapOnCategoryType(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case  "Diet": presenter.displaySecletedCategory(.diet)
        case "Allergies": presenter.displaySecletedCategory(.health)
        default: break
        }
    }
    @objc func clearAllSelectedValues(_ sender: UIButton) { //ref. добавить функционал
        fatalError("d")
    }
    //MARK: - Layouts
    private func setupCategoryTypeBoard() {
        view.addSubview(backgroundViewForCollection)
        for subview in [dietsButton, allergiesButton, lineView] { backgroundViewForCollection.addSubview(subview) }
        NSLayoutConstraint.activate([
            backgroundViewForCollection.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundViewForCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundViewForCollection.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundViewForCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dietsButton.topAnchor.constraint(equalTo: backgroundViewForCollection.topAnchor, constant: 5),
            dietsButton.leftAnchor.constraint(equalTo: backgroundViewForCollection.leftAnchor, constant: 50),
            dietsButton.heightAnchor.constraint(equalToConstant: 35),
            
            allergiesButton.topAnchor.constraint(equalTo: backgroundViewForCollection.topAnchor, constant: 5),
            allergiesButton.rightAnchor.constraint(equalTo: backgroundViewForCollection.rightAnchor, constant: -50),
            allergiesButton.heightAnchor.constraint(equalToConstant: 35),
            
            lineView.topAnchor.constraint(equalTo: dietsButton.bottomAnchor, constant: 2),
            lineView.leftAnchor.constraint(equalTo: backgroundViewForCollection.leftAnchor),
            lineView.rightAnchor.constraint(equalTo: backgroundViewForCollection.rightAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    private func setupCategoryValueCollection(){
        collectionVFilterValues.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
        collectionVFilterValues.dataSource = self
        collectionVFilterValues.delegate = self
        backgroundViewForCollection.addSubview(collectionVFilterValues)
        NSLayoutConstraint.activate([
            collectionVFilterValues.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 3),
            collectionVFilterValues.leftAnchor.constraint(equalTo: backgroundViewForCollection.leftAnchor, constant: 5),
            collectionVFilterValues.rightAnchor.constraint(equalTo: backgroundViewForCollection.rightAnchor, constant: -5),
            collectionVFilterValues.bottomAnchor.constraint(equalTo: backgroundViewForCollection.bottomAnchor)
        ])
    }
}
//MARK: - CollectionView
extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = categoryValues?.count else { return 0}
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier, for: indexPath) as! CategoryCollectionCell
        cell.configure(value: categoryValues![indexPath.row], index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print(indexPath.row)
        presenter.selectCategoryValue(index: indexPath.row)
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension FilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let minimumSpacing: CGFloat = 5.0
        let maximumSpacing: CGFloat = 8.0
        
        let totalSpacing = minimumSpacing + maximumSpacing // Total spacing
        let availableWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        let spacing = min(maximumSpacing, (availableWidth - totalSpacing) / CGFloat(3 - 1))
        return UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: spacing / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = categoryValues![indexPath.row].title
        if let font = UIFont(name: "Helvetica", size: 18) {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (text as NSString).size(withAttributes: fontAttributes)
            let heigh = CGFloat(30)
            let width = size.width
            return CGSize(width: CGFloat(width), height: heigh)
        }
        return CGSize(width: 0, height: 0)
    }
}
//MARK: - FilterViewDelegate
extension FilterViewController: FilterViewDelegate  {
    func updateCategoryView(categoryType: CategoryType) { //ref.
        UIView.animate(withDuration: 0.5) {
            switch categoryType {
            case .health:
                self.dietsButton.setTitleColor(UIColor.notSelected, for: .normal)
                self.allergiesButton.setTitleColor(UIColor.selected, for: .normal)
            case .diet:
                self.allergiesButton.setTitleColor(UIColor.notSelected, for: .normal)
                self.dietsButton.setTitleColor(UIColor.selected, for: .normal)
            }
            self.lineView.lineStartPosition = categoryType
        }
    }
    func updateCollectionView(categoryValues: [CategoryValueProtocol]) {
        self.categoryValues = categoryValues
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionVFilterValues.reloadData() //ref
        }
    }
}
