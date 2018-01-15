//
//  ProductOptionsCollectionDataSource.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ProductOptionCollectionDataSourceProtocol: class {
    func numberOfItems() -> Int
    func item(for index: Int) -> String
    func isItemSelected(at index: Int) -> Bool
}

class ProductOptionCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    weak var delegate: ProductOptionCollectionDataSourceProtocol?
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return productOptionCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    // MARK: - Private
    
    private func productOptionCell(collectionView: UICollectionView, indexPath: IndexPath) -> ProductOptionCollectionViewCell {
        let reuseIdentifier = String(describing: ProductOptionCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductOptionCollectionViewCell
        let item = delegate?.item(for: indexPath.row) ?? ""
        let isItemSelected = delegate?.isItemSelected(at: indexPath.row) ?? false
        cell.configure(with: item, selected: isItemSelected)
        
        return cell
    }
}
