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
}

class ProductOptionsViewController: UIViewController, ProductOptionsCollectionDataSourceProtocol, ProductOptionsCollectionDelegateProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    
    var options = [ProductOption]()
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
            return option.values.count
        }
        return 0
    }
    
    func item(at optionIndex: Int, valueIndex: Int) -> String {
        if optionIndex < options.count {
            let option = options[optionIndex]
            return option.values[valueIndex]
        }
        return String()
    }
    
    func sectionTitle(for sectionIndex: Int) -> String {
        if sectionIndex < options.count {
            return options[sectionIndex].name
        }
        return String()
    }
    
    // MARK: - ProductOptionsCollectionDelegateProtocol
}
