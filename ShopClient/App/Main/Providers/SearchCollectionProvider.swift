//
//  SearchCollectionProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol SearchCollectionProviderDelegate: class {
    func provider(_ provider: SearchCollectionProvider, didSelect category: Category)
}

class SearchCollectionProvider: NSObject {
    var categories: [Category] = []
    
    weak var delegate: SearchCollectionProviderDelegate?
}

// MARK: - UICollectionViewDataSource

extension SearchCollectionProvider: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellName = String(describing: CategoryCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.row]
        cell.configure(with: category)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchCollectionProvider: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        let category = categories[indexPath.row]
        delegate.provider(self, didSelect: category)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchCollectionProvider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CategoryCollectionViewCell.cellSize
    }
}
