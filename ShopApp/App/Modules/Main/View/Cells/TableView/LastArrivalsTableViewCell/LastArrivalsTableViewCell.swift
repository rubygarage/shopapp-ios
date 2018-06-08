//
//  LastArrivalsTableViewCell.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol LastArrivalsTableCellDelegate: class {
    func tableViewCell(_ tableViewCell: LastArrivalsTableViewCell, didSelect product: Product)
}

class LastArrivalsTableViewCell: UITableViewCell, LastArrivalsTableCellProviderDelegate {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightLayoutConstraint: NSLayoutConstraint!
    
    private let rowHeight: CGFloat = 200
    private let numberOfRowsForVerticalLayout: CGFloat = 5
    
    private var collectionProvider: LastArrivalsTableCellProvider!
    private var products: [Product] = []
    
    private var verticalLayoutContentInset: UIEdgeInsets {
        var contentInset = GridCollectionViewCell.defaultCollectionViewInsets
        contentInset.top = 0
        contentInset.bottom = 0
        
        return contentInset
    }
    private var verticalLayoutHeight: CGFloat {
        return GridCollectionViewCell.cellSize.height * numberOfRowsForVerticalLayout
    }
    
    weak var delegate: LastArrivalsTableCellDelegate?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    // MARK: - Setup
    
    func configure(with products: [Product], isVerticalLayout: Bool = false) {
        self.products = products
        collectionProvider.products = products
        collectionProvider.isVerticalLayout = isVerticalLayout
        collectionView.contentInset = isVerticalLayout ? verticalLayoutContentInset : .zero
        collectionViewHeightLayoutConstraint.constant = isVerticalLayout ? verticalLayoutHeight : rowHeight
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = isVerticalLayout ? .vertical : .horizontal
        }
        
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.registerNibForCell(LastArrivalsCollectionViewCell.self)
        collectionView.registerNibForCell(GridCollectionViewCell.self)
        
        collectionProvider = LastArrivalsTableCellProvider()
        collectionProvider.delegate = self
        collectionView.dataSource = collectionProvider
        collectionView.delegate = collectionProvider
    }
    
    // MARK: - LastArrivalsTableCellProviderDelegate
    
    func provider(_ provider: LastArrivalsTableCellProvider, didSelect product: Product) {
        delegate?.tableViewCell(self, didSelect: product)
    }
}
