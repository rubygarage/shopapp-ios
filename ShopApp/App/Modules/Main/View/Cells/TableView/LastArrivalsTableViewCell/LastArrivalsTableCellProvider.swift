//
//  LastArrivalsCollectionProvider.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol LastArrivalsTableCellProviderDelegate: class {
    func provider(_ provider: LastArrivalsTableCellProvider, didSelect product: Product)
}

class LastArrivalsTableCellProvider: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let lastArrivalsTableCellSize = CGSize(width: 200, height: 200)
    
    var products: [Product] = []
    
    weak var delegate: LastArrivalsTableCellProviderDelegate?
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LastArrivalsCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
        let product = products[indexPath.row]
        cell.configure(with: product)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        let product = products[indexPath.row]
        delegate.provider(self, didSelect: product)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return lastArrivalsTableCellSize
    }
}
