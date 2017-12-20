//
//  SearchCollectionDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol SearchCollectionDataSourceProtocol {
    func categoriesCount() -> Int
    func category(at index: Int) -> Category
}

class SearchCollectionDataSource: NSObject, UICollectionViewDataSource {
    var delegate: SearchCollectionDataSourceProtocol!
    
    init(delegate: SearchCollectionDataSourceProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.categoriesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCollectionViewCell.self), for: indexPath) as! CategoryCollectionViewCell
        let category = delegate.category(at: indexPath.row)
        cell.configure(with: category)
        
        return cell
    }
}
