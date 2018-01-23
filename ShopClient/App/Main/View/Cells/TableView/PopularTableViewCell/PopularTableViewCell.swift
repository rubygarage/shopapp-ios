//
//  PopularTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol PopularCellDelegate: class {
    func didSelectPopularProduct(at index: Int)
}

class PopularTableViewCell: UITableViewCell, PopularTableDataSourceProtocol, PopularTableDelegateProtocol {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var dataSource: PopularTableDataSource!
    // swiftlint:disable weak_delegate
    private var delegate: PopularTableDelegate!
    // swiftlint:enable weak_delegate
    private var products = [Product]()
    
    weak var cellDelegate: PopularCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupCollectionView()
    }
    
    // MARK: - Public
    
    func configure(with products: [Product]?) {
        if let items = products {
            self.products = items
            updateCollectionViewHeight()
            collectionView.reloadData()
        }
    }
    
    // MARK: - Private
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: GridCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: GridCollectionViewCell.self))
        
        dataSource = PopularTableDataSource()
        dataSource.delegate = self
        collectionView.dataSource = dataSource
        
        delegate = PopularTableDelegate()
        delegate.delegate = self
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
