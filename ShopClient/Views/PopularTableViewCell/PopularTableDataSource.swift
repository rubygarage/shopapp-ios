//
//  PopularTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol PopularTableDataSourceProtocol {
    func numberOfProducts() -> Int
    func item(for index: Int) -> Product
}

class PopularTableDataSource: NSObject, UICollectionViewDataSource {
    var delegate: PopularTableDataSourceProtocol!
    
    init(delegate: PopularTableDataSourceProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfProducts() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = String(describing: GridCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GridCollectionViewCell
        let item = delegate.item(for: indexPath.row)
        cell.configure(with: item)
        
        return cell
    }
}
