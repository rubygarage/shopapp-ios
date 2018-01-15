//
//  ProductOptionsCollectionDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ProductOptionsCollectionDataSourceProtocol: class {
    func optionsCount() -> Int
    func itemsCount(in optionIndex: Int) -> Int
    func items(at optionIndex: Int) -> (values: [String], selectedValue: String)
    func sectionTitle(for sectionIndex: Int) -> String
}

class ProductOptionsCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    weak var delegate: (ProductOptionsCollectionDataSourceProtocol & ProductOptionsCellDelegate)?
    
    // MARK: - UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return delegate?.optionsCount() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsCount = delegate?.itemsCount(in: section) ?? 0
        return itemsCount > 1 ? 1 : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductOptionsCollectionViewCell.self), for: indexPath) as! ProductOptionsCollectionViewCell
        let items = delegate?.items(at: indexPath.section) ?? (values: [String](), selectedValue: "")
        cell.configure(with: items.values, selectedValue: items.selectedValue, cellDelegate: delegate)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: ProductOptionHeaderView.self), for: indexPath) as! ProductOptionHeaderView
        let text = delegate?.sectionTitle(for: indexPath.section) ?? ""
        headerView.configure(with: text)
        
        return headerView
    }
}
