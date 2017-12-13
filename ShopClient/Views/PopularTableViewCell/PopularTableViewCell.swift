//
//  PopularTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol PopularCellDelegate {
    func didSelectPopularProduct(at index: Int)
}

class PopularTableViewCell: UITableViewCell, PopularTableDataSourceProtocol, PopularTableDelegateProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var dataSource: PopularTableDataSource!
    var delegate: PopularTableDelegate!
    var cellDelegate: PopularCellDelegate?
    var products = [Product]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupCollectionView()
    }
    
    // MARK: - public
    func configure(with products: [Product]?, cellDelegate: PopularCellDelegate?) {
        if let items = products {
            self.products = items
            updateCollectionViewHeight()
            collectionView.reloadData()
        }
        self.cellDelegate = cellDelegate
    }
    
    // MARK: - private
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: GridCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: GridCollectionViewCell.self))
        
        dataSource = PopularTableDataSource(delegate: self)
        collectionView.dataSource = dataSource
        
        delegate = PopularTableDelegate(delegate: self)
        collectionView.delegate = delegate
        
        collectionView.contentInset = GridCollectionViewCell.collectionViewInsets
    }
    
    private func updateCollectionViewHeight() {
        let cellHeight = GridCollectionViewCell.cellSize.height
        self.collectionViewHeightConstraint.constant = self.products.count > 2 ? cellHeight * 2 : cellHeight
    }
    
    // MARK: - PopularTableDataSourceProtocol
    func numberOfProducts() -> Int {
        return products.count
    }
    
    func item(for index: Int) -> Product {
        return products[index]
    }
    
    // MARK: - PopularTableDelegateProtocol
    func didSelectItem(at index: Int) {
        cellDelegate?.didSelectPopularProduct(at: index)
    }
}
