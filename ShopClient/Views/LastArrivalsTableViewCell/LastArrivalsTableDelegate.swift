//
//  LastArrivalsTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/15/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

let kLastArrivalsTableCellSize = CGSize(width: 200, height: 215)

protocol LastArrivalsTableDelegateProtocol {
    func didSelectItem(at index: Int)
}

let kLastArrivalsLoadMoreWidth: CGFloat = 100

class LastArrivalsTableDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var delegate: LastArrivalsTableDelegateProtocol?
    
    init(delegate: LastArrivalsTableDelegateProtocol?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return kLastArrivalsTableCellSize
    }
}
