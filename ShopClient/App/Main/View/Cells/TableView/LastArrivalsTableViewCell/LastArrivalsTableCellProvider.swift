//
//  LastArrivalsCollectionProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

private let kLastArrivalsTableCellSize = CGSize(width: 200, height: 215)

protocol LastArrivalsTableCellProviderDelegate: class {
    func provider(_ provider: LastArrivalsTableCellProvider, didSelect product: Product)
}

class LastArrivalsTableCellProvider: NSObject {
    var products: [Product] = []
    
    weak var delegate: LastArrivalsTableCellProviderDelegate?
}

// MARK: - UICollectionViewDataSource

extension LastArrivalsTableCellProvider: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellname = String(describing: LastArrivalsCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellname, for: indexPath) as! LastArrivalsCollectionViewCell
        let product = products[indexPath.row]
        cell.configure(with: product)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension LastArrivalsTableCellProvider: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        let product = products[indexPath.row]
        delegate.provider(self, didSelect: product)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LastArrivalsTableCellProvider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return kLastArrivalsTableCellSize
    }
}
