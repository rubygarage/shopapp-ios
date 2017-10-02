//
//  ProductOptionsCollectionDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/2/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ProductOptionsCollectionDelegateProtocol {
    // TODO:
}

let kOptionsHeaderViewSize = CGSize(width: 0, height: 30)

class ProductOptionsCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var delegate: ProductOptionsCollectionDelegateProtocol?
    
    init(delegate: ProductOptionsCollectionDelegateProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return kOptionsHeaderViewSize
    }
}
