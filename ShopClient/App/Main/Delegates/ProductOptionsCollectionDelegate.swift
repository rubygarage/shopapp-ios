//
//  ProductOptionsCollectionDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/2/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ProductOptionsCollectionDelegateProtocol {
    func didSelectItem(at indexPath: IndexPath)
}

let kOptionsHeaderViewSize = CGSize(width: 0, height: 46)

class ProductOptionsCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var delegate: ProductOptionsCollectionDelegateProtocol?
    
    init(delegate: ProductOptionsCollectionDelegateProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return kOptionsHeaderViewSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath)
    }
}
