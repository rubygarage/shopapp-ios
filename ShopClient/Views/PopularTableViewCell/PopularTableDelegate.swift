//
//  PopularTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kPopularSectionNumberOfColumns: CGFloat = 2

protocol PopularTableDelegateProtocol {
    func didSelectItem(at index: Int)
}

class PopularTableDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var delegate: PopularTableDelegateProtocol!
    
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
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = screenWidth / kPopularSectionNumberOfColumns
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
