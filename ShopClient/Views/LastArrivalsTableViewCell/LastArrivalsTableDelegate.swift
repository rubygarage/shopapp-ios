//
//  LastArrivalsTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/15/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol LastArrivalsTableDelegateProtocol {
    func didSelectItem(at index: Int)
    func didTapLoadMore()
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
        if indexPath.section == LastArrivalsSection.product.rawValue {
            delegate?.didSelectItem(at: indexPath.row)
        } else {
            delegate?.didTapLoadMore()
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let numberOfColumn: CGFloat = UIDevice.current.orientation.isPortrait ? kLastArrivalsNumberOfColumnPortrait : kLastArrivalsNumberOfColumnLandscape
        let cellWidth = screenWidth / numberOfColumn
        
        switch indexPath.section {
        case LastArrivalsSection.product.rawValue:
            return CGSize(width: cellWidth, height: cellWidth)
        case LastArrivalsSection.loadMore.rawValue:
            return CGSize(width: kLastArrivalsLoadMoreWidth, height: cellWidth)
        default:
            return CGSize.zero
        }
    }
}
