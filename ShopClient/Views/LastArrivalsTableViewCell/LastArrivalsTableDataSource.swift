//
//  LastArrivalsTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/15/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol LastArrivalsTableDataSourceProtocol {
    func numberOfSections() -> Int
    func numberOfProducts() -> Int
    func item(for index: Int) -> Product
}

class LastArrivalsTableDataSource: NSObject, UICollectionViewDataSource {
    var delegate: LastArrivalsTableDataSourceProtocol?
    
    init(delegate: LastArrivalsTableDataSourceProtocol?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return delegate?.numberOfSections() ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == LastArrivalsSection.product.rawValue ? delegate?.numberOfProducts() ?? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == LastArrivalsSection.product.rawValue {
            return lastArrivalsCell(collectionView: collectionView, indexPath: indexPath)
        }
        return loadMoreCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    // MARK: - private
    private func lastArrivalsCell(collectionView: UICollectionView, indexPath: IndexPath) -> LastArrivalsCollectionViewCell {
        let reuseIdentifier = String(describing: LastArrivalsCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LastArrivalsCollectionViewCell
        let item = delegate?.item(for: indexPath.row)
        cell.configure(with: item!)
        
        return cell
    }
    
    private func loadMoreCell(collectionView: UICollectionView, indexPath: IndexPath) -> LastArrivalsLoadMoreCell {
        let reuseIdentifier = String(describing: LastArrivalsLoadMoreCell.self)
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LastArrivalsLoadMoreCell
    }
}
