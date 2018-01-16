//
//  SearchCollectionDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol SearchCollectionDelegateProtocol: class {
    func didSelectCategory(at index: Int)
}

class SearchCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var delegate: SearchCollectionDelegateProtocol?
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCategory(at: indexPath.row)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CategoryCollectionViewCell.cellSize
    }
}
