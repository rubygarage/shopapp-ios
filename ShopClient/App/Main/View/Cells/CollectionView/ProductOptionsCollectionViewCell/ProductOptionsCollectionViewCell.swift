//
//  ProductOptionsCollectionViewCell.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ProductOptionsCellDelegate: class {
    func didSelectItem(with values: [String], selectedValue: String)
}

class ProductOptionsCollectionViewCell: UICollectionViewCell, ProductOptionCollectionDataSourceProtocol, ProductOptionCollectionDelegateProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: ProductOptionCollectionDataSource?
    private var delegate: ProductOptionCollectionDelegate?
    private var cellDelegate: ProductOptionsCellDelegate?
    private var values = [String]()
    private var selectedValue = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: ProductOptionCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: ProductOptionCollectionViewCell.self))

        dataSource = ProductOptionCollectionDataSource(delegate: self)
        collectionView.dataSource = dataSource
        
        delegate = ProductOptionCollectionDelegate(delegate: self)
        collectionView.delegate = delegate
    }
    
    func configure(with values: [String], selectedValue: String, cellDelegate: ProductOptionsCellDelegate?) {
        self.values = values
        self.selectedValue = selectedValue
        self.cellDelegate = cellDelegate
        collectionView.reloadData()
    }
    
    // MARK: - ProductOptionCollectioDataSourceProtocol
    func numberOfItems() -> Int {
        return values.count
    }
    
    func item(for index: Int) -> String {
        return values[index]
    }
    
    func isItemSelected(at index: Int) -> Bool {
        return values[index] == selectedValue
    }
    
    // MARK: - ProductOptionCollectionDelegateProtocol
    func didSelectItem(at index: Int) {
        cellDelegate?.didSelectItem(with: values, selectedValue: values[index])
    }
}
