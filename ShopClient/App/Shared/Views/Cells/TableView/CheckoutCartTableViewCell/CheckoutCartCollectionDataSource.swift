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
    weak var delegate: CheckoutCartCollectionDataSourceDelegate?
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.itemsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CheckoutCartCollectionCell.self), for: indexPath) as! CheckoutCartCollectionCell
        
        if let item = delegate?.item(at: indexPath.row) {
            cell.configure(with: item.image, productVariantId: item.productVariantId)
        }
        
        return cell
    }
}
