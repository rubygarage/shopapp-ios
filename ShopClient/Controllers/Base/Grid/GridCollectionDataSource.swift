//
//  GridCollectionDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol GridCollectionDataSourceProtocol {
    func numberOfItems() -> Int
    func item(for indexPath: IndexPath) -> ProductEntity
}

class GridCollectionDataSource: NSObject, UICollectionViewDataSource {
    var delegate: GridCollectionDataSourceProtocol?
    
    init(delegate: GridCollectionDataSourceProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfItems() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = String(describing: GridCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GridCollectionViewCell
        let item = delegate?.item(for: indexPath)
        cell.configure(with: item!)
        
        return cell
    }
}
