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
        return delegate?.optionsCount() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsCount = delegate?.itemsCount(in: section) ?? 0
        return itemsCount > 1 ? 1 : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductOptionsCollectionViewCell.self), for: indexPath) as! ProductOptionsCollectionViewCell
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: ProductOptionHeaderView.self), for: indexPath) as! ProductOptionHeaderView
        let text = delegate?.sectionTitle(for: indexPath.section) ?? ""
        headerView.configure(with: text)
        
        return headerView
    }
}
