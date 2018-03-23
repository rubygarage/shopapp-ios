//
//  CheckoutCartCollectionProvider.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 3/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol CheckoutCartCollectionProviderDelegate: class {
    func provider(_ provider: CheckoutCartCollectionProvider, didSelectItemWith productVariantId: String)
}

class CheckoutCartCollectionProvider: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var images: [Image] = []
    var productVariantIds: [String] = []
    
    weak var delegate: CheckoutCartCollectionProviderDelegate?
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CheckoutCartCollectionCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
        
        let image = images[indexPath.row]
        let productVariantId = productVariantIds[indexPath.row]
        cell.configure(with: image, productVariantId: productVariantId)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CheckoutCartCollectionCell {
            delegate?.provider(self, didSelectItemWith: cell.productVariantId)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CheckoutCartCollectionCell.cellSize
    }
}
