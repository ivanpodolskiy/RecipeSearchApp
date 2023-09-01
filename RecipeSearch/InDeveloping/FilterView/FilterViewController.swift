//
//  FilterViewController.swift
//  RecipeSearch
//
//  Created by user on 14.06.2023.
//

import UIKit

class CategoriesManager {
    
    private let categories = Category(dietValue: [ValueCategory(name: "Balanced"), ValueCategory(name: "Alcohol-free"), ValueCategory(name: "High-Fiber")], allergiesValue: [ValueCategory(name: "Celery-free"), ValueCategory(name: "Crustacean-free"), ValueCategory(name: "Dairy-free")])
    
    
    //Пока не нужно
//    private var selectedCetegories: Category?
    //    init(selectedCetegories: Category) {
    //        self.selectedCetegories = selectedCetegories
    //    }
    
    var count: Int {
        get {
            return categories.count
        }
    }
    func returnValuesList(section: Int) -> [ValueCategory]{
        return categories.getList(section)
    }
    
    func returnNameCategory(section: Int) -> String {
        categories.getName(section)
    }

    
    func chooseCategoriy(section: Int, index: Int) {
        if let categoryName = categories[section] {
            var value = categoryName[index]
            value.selectiong()
            // работа с сетью
            
        }
        }
    
    
    }
    


class FilterViewController: UIViewController  {
    

    let categoriesManager = CategoriesManager()
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        collectionView.register(FilterViewCell.self, forCellWithReuseIdentifier: FilterViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.3)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 10)
        section.supplementaryContentInsetsReference = .automatic
        
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let header =  NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        return header
    }
}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //Почему то вызвается несколько раз 
        print ("Section         \(categoriesManager.count)")
        return         categoriesManager.count

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        categoriesManager.returnValuesList(section: section).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print ("section \(indexPath.section). indexRow \(indexPath.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterViewCell.identifier, for: indexPath) as! FilterViewCell
        let listCategory = categoriesManager.returnValuesList(section: indexPath.section)
        let item = listCategory[indexPath.row]
        cell.setButtonText(item.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            switch kind {
        case UICollectionView.elementKindSectionHeader:
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as! SectionHeader
                let nameSection = categoriesManager.returnNameCategory(section: indexPath.section)
//            let nameSection = categories.getName(indexPath.section)
            sectionHeader.label.text = nameSection
                return sectionHeader
        default:
            return UICollectionReusableView()
        }
    }
}

