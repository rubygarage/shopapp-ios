//
//  CheckoutCartCollectionDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutCartCollectionDataSourceDelegate {
    func itemsCount() -> Int
    func item(at index: Int) -> CartProduct
}

class CheckoutCartCollectionDataSource: NSObject, UICollectionViewDataSource {
    var delegate: CheckoutCartCollectionDataSourceDelegate!
    
    init(delegate: CheckoutCartCollectionDataSourceDelegate) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.itemsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CheckoutCartCollectionCell.self), for: indexPath) as! CheckoutCartCollectionCell
        cell.configure(with: delegate.item(at: indexPath.row))
        
        return cell
    }
}
