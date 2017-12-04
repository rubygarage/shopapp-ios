//
//  LastArrivalsTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol LastArrivalsCellDelegate {
    func didSelectProduct(at index: Int)
}

let kLastArrivalsNumberOfSections = 1

class LastArrivalsTableViewCell: UITableViewCell, LastArrivalsTableDataSourceProtocol, LastArrivalsTableDelegateProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: LastArrivalsTableDataSource?
    var delegate: LastArrivalsTableDelegate?
    var cellDelegate: LastArrivalsCellDelegate?
    
    var products = [Product]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: LastArrivalsCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: LastArrivalsCollectionViewCell.self))
        
        dataSource = LastArrivalsTableDataSource(delegate: self)
        collectionView.dataSource = dataSource
        
        delegate = LastArrivalsTableDelegate(delegate: self)
        collectionView.delegate = delegate
    }
    
    func configure(with products: [Product]?, cellDelegate: LastArrivalsCellDelegate?) {
        if let items = products {
            self.products = items
            collectionView.reloadData()
        }
        self.cellDelegate = cellDelegate
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
        cellDelegate?.didSelectProduct(at: index)
    }
}
