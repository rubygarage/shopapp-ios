//
//  SearchCollectionDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol SearchCollectionDataSourceProtocol: class {
    func categoriesCount() -> Int
    func category(at index: Int) -> Category
}

class SearchCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    weak var delegate: SearchCollectionDataSourceProtocol?
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.categoriesCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCollectionViewCell.self), for: indexPath) as! CategoryCollectionViewCell
        if let category = delegate?.category(at: indexPath.row) {
            cell.configure(with: category)
        }
        return cell
    }
}
