//
//  LastArrivalsTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol LastArrivalsCellDelegate: class {
    func didSelectLastArrivalsProduct(at index: Int)
}

private let kLastArrivalsNumberOfSections = 1

class LastArrivalsTableViewCell: UITableViewCell, LastArrivalsTableDataSourceProtocol, LastArrivalsTableDelegateProtocol {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var dataSource: LastArrivalsTableDataSource!
    // swiftlint:disable weak_delegate
    private var delegate: LastArrivalsTableDelegate!
    // swiftlint:enable weak_delegate
    private var products = [Product]()
    
    weak var cellDelegate: LastArrivalsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: LastArrivalsCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: LastArrivalsCollectionViewCell.self))
        
        dataSource = LastArrivalsTableDataSource()
        dataSource.delegate = self
        collectionView.dataSource = dataSource
        
        delegate = LastArrivalsTableDelegate()
        delegate.delegate = self
        collectionView.delegate = delegate
    }
    
    func configure(with products: [Product]?) {
        if let items = products {
            self.products = items
            collectionView.reloadData()
        }
    }
    
    // MARK: - LastArrivalsTableDataSourceProtocol
    
    func numberOfSections() -> Int {
        return kLastArrivalsNumberOfSections
    }
    
    func numberOfProducts() -> Int {
        return products.count
    }
    
    func item(for index: Int) -> Product {
        return products[index]
    }
    
    // MARK: - LastArrivalsTableDelegateProtocol
    
    func didSelectItem(at index: Int) {
        cellDelegate?.didSelectLastArrivalsProduct(at: index)
    }
}
