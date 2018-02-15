//
//  CheckoutCartTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopClient_Gateway

protocol CheckoutCartTableViewCellDelegate: class {
    func didSelectItem(with productVariantId: String, at index: Int)
}

class CheckoutCartTableViewCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var collectionDataSource: CheckoutCartCollectionDataSource!
    // swiftlint:disable weak_delegate
    private var collectionDelegate: CheckoutCartCollectionDelegate!
    // swiftlint:enable weak_delegate
    
    fileprivate var images: [Image]!
    fileprivate var productVariantIds: [String]!
    fileprivate var index = 0
    
    weak var cellDelegate: CheckoutCartTableViewCellDelegate?
    
    // MARK: - View lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    // MARK: - Setup
    
    public func configure(with items: [Image], productVariantIds: [String], index: Int? = nil) {
        images = items
        self.productVariantIds = productVariantIds
        if let index = index {
            self.index = index
        }
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.registerNibForCell(CheckoutCartCollectionCell.self)
        
        collectionDataSource = CheckoutCartCollectionDataSource()
        collectionDataSource.delegate = self
        collectionView.dataSource = collectionDataSource
        
        collectionDelegate = CheckoutCartCollectionDelegate()
        collectionDelegate.delegate = self
        collectionView.delegate = collectionDelegate
    }
}

// MARK: - CheckoutCartCollectionDataSourceDelegate

extension CheckoutCartTableViewCell: CheckoutCartCollectionDataSourceDelegate {
    func itemsCount() -> Int {
        return images.count
    }
    
    func item(at index: Int) -> (image: Image, productVariantId: String) {
        return (image: images[index], productVariantId: productVariantIds[index])
    }
}

// MARK: - CheckoutCartCollectionDelegateProtocol

extension CheckoutCartTableViewCell: CheckoutCartCollectionDelegateProtocol {
    func didSelectItem(with productVariantId: String) {
        cellDelegate?.didSelectItem(with: productVariantId, at: index)
    }
}
