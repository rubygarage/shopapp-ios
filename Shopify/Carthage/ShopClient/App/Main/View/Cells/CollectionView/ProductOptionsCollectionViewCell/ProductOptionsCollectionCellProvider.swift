//
//  ProductOptionsCollectionProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

private let kOptionCollectionViewCellAdditionalWidth = CGFloat(24.0)

protocol ProductOptionCollectionCellProviderDelegate: class {
    func provider(_ provider: ProductOptionCollectionCellProvider, didSelect value: String)
}

class ProductOptionCollectionCellProvider: NSObject {
    var values: [String] = []
    var selectedValue = ""
    
    weak var delegate: ProductOptionCollectionCellProviderDelegate?
}

// MARK: - UICollectionViewDataSource

extension ProductOptionCollectionCellProvider: UICollectionViewDataSource {
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
}

// MARK: - UICollectionViewDelegate

extension ProductOptionCollectionCellProvider: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = values[indexPath.row]
        let font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        let attributes = [NSFontAttributeName: font]
        let width = (text as NSString).size(attributes: attributes).width + kOptionCollectionViewCellAdditionalWidth
        return CGSize(width: width, height: kOptionCollectionViewCellHeight)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductOptionCollectionCellProvider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        let value = values[indexPath.row]
        delegate.provider(self, didSelect: value)
    }
}
