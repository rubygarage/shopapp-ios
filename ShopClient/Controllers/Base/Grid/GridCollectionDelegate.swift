//
//  GridCollectionDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

let kGridNumberOfColumnPortrait: CGFloat = 2
let kGridNumberOfColumnLandscape: CGFloat = 3
let kCellImageRatio: CGFloat = 16 / 9

protocol GridCollectionDelegateProtocol {
    func didSelectItem(at index: Int)
}

class GridCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var delegate: GridCollectionDelegateProtocol?
    
    init(delegate: GridCollectionDelegateProtocol) {
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
        let numberOfColumn: CGFloat = UIDevice.current.orientation.isPortrait ? kGridNumberOfColumnPortrait : kGridNumberOfColumnLandscape
        let cellWidth = screenWidth / numberOfColumn
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
