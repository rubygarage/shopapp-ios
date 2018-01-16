//
//  LastArrivalsTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/15/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol LastArrivalsTableDataSourceProtocol: class {
    func numberOfSections() -> Int
    func numberOfProducts() -> Int
    func item(for index: Int) -> Product
}

class LastArrivalsTableDataSource: NSObject, UICollectionViewDataSource {
    weak var delegate: LastArrivalsTableDataSourceProtocol?
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return delegate?.numberOfSections() ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfProducts() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return lastArrivalsCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    // MARK: - Private
    
    private func lastArrivalsCell(collectionView: UICollectionView, indexPath: IndexPath) -> LastArrivalsCollectionViewCell {
        let reuseIdentifier = String(describing: LastArrivalsCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LastArrivalsCollectionViewCell
        let item = delegate?.item(for: indexPath.row)
        cell.configure(with: item!)
        
        return cell
    }
}
