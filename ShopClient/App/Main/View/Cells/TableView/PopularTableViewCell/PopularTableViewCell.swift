//
//  PopularTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol PopularTableCellDelegate: class {
    func tableViewCell(_ tableViewCell: PopularTableViewCell, didSelect product: Product)
}

class PopularTableViewCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var collectionProvider: PopularTableCellProvider!
    private var products: [Product] = []
    
    weak var delegate: PopularTableCellDelegate?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupCollectionView()
    }
    
    // MARK: - Setup
    
    func configure(with products: [Product]) {
        self.products = products
        updateCollectionViewHeight()
        collectionProvider.products = products
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        let cellName = String(describing: GridCollectionViewCell.self)
        let nib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellName)
        
        collectionProvider = PopularTableCellProvider()
        collectionProvider.delegate = self
        collectionView.dataSource = collectionProvider
        collectionView.delegate = collectionProvider
        
        collectionView.contentInset = GridCollectionViewCell.popularCollectionViewInsets
    }
    
    private func updateCollectionViewHeight() {
        let cellHeight = GridCollectionViewCell.cellSize.height
        self.collectionViewHeightConstraint.constant = self.products.count > 2 ? cellHeight * 2 : cellHeight
    }
}

// MARK: - PopularCollectionProviderDelegate

extension PopularTableViewCell: PopularTableCellProviderDelegate {
    func provider(_ provider: PopularTableCellProvider, didSelect product: Product) {
        delegate?.tableViewCell(self, didSelect: product)
    }
}
