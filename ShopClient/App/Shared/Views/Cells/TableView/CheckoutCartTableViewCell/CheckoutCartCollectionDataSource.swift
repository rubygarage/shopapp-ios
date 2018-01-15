//
//  CheckoutCartCollectionDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutCartCollectionDataSourceDelegate: class {
    func itemsCount() -> Int
    func item(at index: Int) -> (image: Image, productVariantId: String)
}

class CheckoutCartCollectionDataSource: NSObject, UICollectionViewDataSource {
    private var delegate: CheckoutCartCollectionDataSourceDelegate!
    
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
        let item = delegate.item(at: indexPath.row)
        cell.configure(with: item.image, productVariantId: item.productVariantId)
        
        return cell
    }
}
