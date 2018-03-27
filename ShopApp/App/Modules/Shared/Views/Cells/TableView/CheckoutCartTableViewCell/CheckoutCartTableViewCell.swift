//
//  CheckoutCartTableViewCell.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol CheckoutCartTableViewCellDelegate: class {
    func tableViewCell(_ cell: CheckoutCartTableViewCell, didSelect productVariantId: String, at index: Int)
}

class CheckoutCartTableViewCell: UITableViewCell, CheckoutCartCollectionProviderDelegate {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var collectionProvider: CheckoutCartCollectionProvider!
    private var images: [Image]!
    private var productVariantIds: [String]!
    private var index = 0
    
    weak var delegate: CheckoutCartTableViewCellDelegate?
    
    // MARK: - View lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    // MARK: - Setup
    
    func configure(with items: [Image], productVariantIds: [String], index: Int? = nil) {
        setupCollectionView()
        
        collectionProvider.images = items
        collectionProvider.productVariantIds = productVariantIds
        
        if let index = index {
            self.index = index
        }
    }
    
    private func setupCollectionView() {
        collectionView.registerNibForCell(CheckoutCartCollectionCell.self)
        
        collectionProvider = CheckoutCartCollectionProvider()
        collectionProvider.delegate = self
        collectionView.dataSource = collectionProvider
        collectionView.delegate = collectionProvider
    }

    // MARK: - CheckoutCartCollectionProviderDelegate

    func provider(_ provider: CheckoutCartCollectionProvider, didSelectItemWith productVariantId: String) {
        delegate?.tableViewCell(self, didSelect: productVariantId, at: index)
    }
}
