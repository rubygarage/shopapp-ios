//
//  ProductOptionsViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

let kOptionCellEstimatedSize = CGSize(width: 100, height: 31)

protocol ProductOptionsControllerProtocol {
    func didCalculate(collectionViewHeight: CGFloat)
    func didSelectOption(with name: String, value: String)
}

class ProductOptionsViewController: UIViewController, ProductOptionsCollectionDataSourceProtocol, ProductOptionsCollectionDelegateProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    
    var options = [ProductOptionEntity]()
    var selectedOptions = [SelectedOption]()
    var collectionDataSource: ProductOptionsCollectionDataSource?
    var collectionDelegate: ProductOptionsCollectionDelegate?
    var controllerDelegate: ProductOptionsControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        controllerDelegate?.didCalculate(collectionViewHeight: collectionView.contentSize.height)
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: ProductOptionCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: ProductOptionCollectionViewCell.self))
        
        let headerNib = UINib(nibName: String(describing: ProductOptionHeaderView.self), bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: ProductOptionHeaderView.self))
        
        collectionLayout.estimatedItemSize = kOptionCellEstimatedSize
        
        collectionDataSource = ProductOptionsCollectionDataSource(delegate: self)
        collectionView.dataSource = collectionDataSource
        
        collectionDelegate = ProductOptionsCollectionDelegate(delegate: self)
        collectionView.delegate = collectionDelegate
    }
    
    // MARK: - ProductOptionsCollectionDataSourceProtocol
    func optionsCount() -> Int {
        return options.count
    }
    
    func itemsCount(in optionIndex: Int) -> Int {
        if optionIndex < options.count {
            let option = options[optionIndex]
            return option.valuesArray.count
        }
        return 0
    }
    
    func item(at optionIndex: Int, valueIndex: Int) -> String {
        if optionIndex < options.count {
            let option = options[optionIndex]
            return option.valuesArray[valueIndex]
        }
        return String()
    }
    
    func sectionTitle(for sectionIndex: Int) -> String {
        if sectionIndex < options.count {
            return options[sectionIndex].name ?? String()
        }
        return String()
    }
    
    func isItemSelected(at indexPath: IndexPath) -> Bool {
        if indexPath.section < options.count && indexPath.section < selectedOptions.count {
            let item = options[indexPath.section].valuesArray[indexPath.row]
            let selectedItem = selectedOptions[indexPath.section].value
            return item == selectedItem
        }
        return false
    }
    
    // MARK: - ProductOptionsCollectionDelegateProtocol
    func didSelectItem(at indexPath: IndexPath) {
        if indexPath.section < options.count {
            let name = options[indexPath.section].name ?? String()
            let value = options[indexPath.section].valuesArray[indexPath.row]
            controllerDelegate?.didSelectOption(with: name, value: value)
        }
    }
}
