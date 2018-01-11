//
//  ProductOptionsCollectionDelegate.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ProductOptionCollectionDelegateProtocol {
    func didSelectItem(at index: Int)
}

class ProductOptionCollectionDelegate: NSObject, UICollectionViewDataSource {
    private var delegate: ProductOptionCollectionDelegateProtocol?
    
    init(delegate: ProductOptionCollectionDelegateProtocol?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
}
