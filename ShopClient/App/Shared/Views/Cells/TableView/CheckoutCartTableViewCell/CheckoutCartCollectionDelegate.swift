//
//  CheckoutCartCollectionDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutCartCollectionDelegateProtocol: class {
    func didSelectItem(with productVariantId: String)
}

class CheckoutCartCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: CheckoutCartCollectionDelegateProtocol?
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CheckoutCartCollectionCell.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CheckoutCartCollectionCell {
            delegate?.didSelectItem(with: cell.productVariantId)
        }
    }
}
