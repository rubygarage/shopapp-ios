//
//  ProductOptionsCollectionViewCell.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ProductOptionsCollectionCellDelegate: class {
    func collectionViewCell(_ collectionViewCell: ProductOptionsCollectionViewCell, didSelectItemWith values: [String], selectedValue: String)
}

class ProductOptionsCollectionViewCell: UICollectionViewCell, ProductOptionsCollectionCellProviderDelegate {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var collectionProvider: ProductOptionsCollectionCellProvider!
    private var selectedValue = ""
    private var values: [String] = []
    
    weak var delegate: ProductOptionsCollectionCellDelegate?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    // MARK: - Setup
    
    func configure(with values: [String], selectedValue: String, delegate: ProductOptionsCollectionCellDelegate?) {
        self.values = values
        self.selectedValue = selectedValue
        self.delegate = delegate
        collectionProvider.values = values
        collectionProvider.selectedValue = selectedValue
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.registerNibForCell(ProductOptionCollectionViewCell.self)

        collectionProvider = ProductOptionsCollectionCellProvider()
        collectionProvider.delegate = self
        collectionView.dataSource = collectionProvider
        collectionView.delegate = collectionProvider
    }
    
    // MARK: - ProductOptionsCollectionCellProviderDelegate
    
    func provider(_ provider: ProductOptionsCollectionCellProvider, didSelect value: String) {
        delegate?.collectionViewCell(self, didSelectItemWith: values, selectedValue: value)
    }
}
