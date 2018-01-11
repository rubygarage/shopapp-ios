//
//  ProductOptionsCollectionDelegate.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

let kOptionCollectionViewCellAdditionalWidth = CGFloat(24.0)

protocol ProductOptionCollectionDelegateProtocol {
    func item(for index: Int) -> String
    func didSelectItem(at index: Int)
}

class ProductOptionCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var delegate: ProductOptionCollectionDelegateProtocol?
    
    init(delegate: ProductOptionCollectionDelegateProtocol?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = delegate?.item(for: indexPath.row) ?? ""
        let font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        let attributes = [NSFontAttributeName: font]
        let width = (text as NSString).size(attributes: attributes).width + kOptionCollectionViewCellAdditionalWidth
        
        return CGSize(width: width, height: kOptionCollectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
}
