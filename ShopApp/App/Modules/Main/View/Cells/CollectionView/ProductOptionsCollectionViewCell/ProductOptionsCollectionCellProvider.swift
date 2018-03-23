//
//  ProductOptionsCollectionProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol ProductOptionsCollectionCellProviderDelegate: class {
    func provider(_ provider: ProductOptionsCollectionCellProvider, didSelect value: String)
}

class ProductOptionsCollectionCellProvider: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let optionCollectionViewCellAdditionalWidth = CGFloat(24.0)
    
    var values: [String] = []
    var selectedValue = ""
    
    weak var delegate: ProductOptionsCollectionCellProviderDelegate?
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductOptionCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
        let value = values[indexPath.row]
        let isSelectedValue = value == selectedValue
        cell.configure(with: value, selected: isSelectedValue)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = values[indexPath.row]
        let font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        let attributes = [NSFontAttributeName: font]
        let width = (text as NSString).size(attributes: attributes).width + optionCollectionViewCellAdditionalWidth
        return CGSize(width: width, height: kOptionCollectionViewCellHeight)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        let value = values[indexPath.row]
        delegate.provider(self, didSelect: value)
    }
}
