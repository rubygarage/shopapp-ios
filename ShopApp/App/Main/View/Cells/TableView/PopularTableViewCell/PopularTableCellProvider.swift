//
//  PopularCollectionProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol PopularTableCellProviderDelegate: class {
    func provider(_ provider: PopularTableCellProvider, didSelect product: Product)
}

class PopularTableCellProvider: NSObject {
    var products: [Product] = []
    
    weak var delegate: PopularTableCellProviderDelegate?
}

// MARK: - UICollectionViewDataSource

extension PopularTableCellProvider: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GridCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
        let product = products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PopularTableCellProvider: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        let product = products[indexPath.row]
        delegate.provider(self, didSelect: product)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PopularTableCellProvider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return GridCollectionViewCell.cellSize
    }
}
