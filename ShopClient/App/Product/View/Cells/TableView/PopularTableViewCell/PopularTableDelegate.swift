//
//  PopularTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol PopularTableDelegateProtocol {
    func didSelectItem(at index: Int)
}

class PopularTableDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var delegate: PopularTableDelegateProtocol!
    
    init(delegate: PopularTableDelegateProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {        
        return GridCollectionViewCell.cellSize
    }
}
