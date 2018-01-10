//
//  ProductOptionsCollectionDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ProductOptionsCollectionDataSourceProtocol {
    func optionsCount() -> Int
    func itemsCount(in optionIndex: Int) -> Int
    func item(at optionIndex: Int, valueIndex: Int) -> String
    func sectionTitle(for sectionIndex: Int) -> String
    func isItemSelected(at indexPath: IndexPath) -> Bool
}

class ProductOptionsCollectionDataSource: NSObject, UICollectionViewDataSource {
    private var delegate: ProductOptionsCollectionDataSourceProtocol?
    
    init(delegate: ProductOptionsCollectionDataSourceProtocol?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let optionsCount = delegate?.optionsCount() ?? 0
        return optionsCount > 1 ? optionsCount : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.itemsCount(in: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductOptionCollectionViewCell.self), for: indexPath) as! ProductOptionCollectionViewCell
        let text = delegate?.item(at: indexPath.section, valueIndex: indexPath.row) ?? String()
        let selected = delegate?.isItemSelected(at: indexPath) ?? false
        cell.configure(with: text, selected: selected)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: ProductOptionHeaderView.self), for: indexPath) as! ProductOptionHeaderView
        let text = delegate?.sectionTitle(for: indexPath.section) ?? String()
        headerView.configure(with: text)
        
        return headerView
    }
}
