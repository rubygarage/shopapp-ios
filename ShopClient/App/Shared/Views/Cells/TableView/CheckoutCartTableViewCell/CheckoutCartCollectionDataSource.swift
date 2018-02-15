//
//  CheckoutCartCollectionDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopClient_Gateway

protocol CheckoutCartCollectionDataSourceDelegate: class {
    func itemsCount() -> Int
    func item(at index: Int) -> (image: Image, productVariantId: String)
}

class CheckoutCartCollectionDataSource: NSObject {
    weak var delegate: CheckoutCartCollectionDataSourceDelegate?
}

// MARK: - UICollectionViewDataSource

extension CheckoutCartCollectionDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.itemsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CheckoutCartCollectionCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
        
        if let item = delegate?.item(at: indexPath.row) {
            cell.configure(with: item.image, productVariantId: item.productVariantId)
        }
        
        return cell
    }
}
