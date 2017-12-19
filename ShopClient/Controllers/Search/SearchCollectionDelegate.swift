//
//  SearchCollectionDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class SearchCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CategoryCollectionViewCell.cellSize
    }
}
