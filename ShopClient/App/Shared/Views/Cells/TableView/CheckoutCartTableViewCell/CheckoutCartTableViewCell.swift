//
//  CheckoutCartTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutCartTableViewCellDelegate: class {
    func didSelectItem(with productVariantId: String, at index: Int)
}

class CheckoutCartTableViewCell: UITableViewCell, CheckoutCartCollectionDataSourceDelegate, CheckoutCartCollectionDelegateProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var images: [Image]!
    private var productVariantIds: [String]!
    private var collectionDataSource: CheckoutCartCollectionDataSource!
    // swiftlint:disable weak_delegate
    private var collectionDelegate: CheckoutCartCollectionDelegate!
    // swiftlint:enable weak_delegate
    private var index = 0
    
    weak var cellDelegate: CheckoutCartTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    public func configure(with items: [Image], productVariantIds: [String], index: Int? = nil) {
        images = items
        self.productVariantIds = productVariantIds
        if let index = index {
            self.index = index
        }
        setupCollectionView()
    }
    
    // MARK: - Private
    
    private func setupCollectionView() {
        let cartNib = UINib(nibName: String(describing: CheckoutCartCollectionCell.self), bundle: nil)
        collectionView.register(cartNib, forCellWithReuseIdentifier: String(describing: CheckoutCartCollectionCell.self))
        
        collectionDataSource = CheckoutCartCollectionDataSource()
        collectionDataSource.delegate = self
        collectionView.dataSource = collectionDataSource
        
        collectionDelegate = CheckoutCartCollectionDelegate()
        collectionDelegate.delegate = self
        collectionView.delegate = collectionDelegate
    }
    
    // MARK: - CheckoutCartCollectionDataSourceDelegate
    
    func itemsCount() -> Int {
        return images.count
    }
    
    func item(at index: Int) -> (image: Image, productVariantId: String) {
        return (image: images[index], productVariantId: productVariantIds[index])
    }
    
    // MARK: - CheckoutCartCollectionDelegateProtocol
    
    func didSelectItem(with productVariantId: String) {
        cellDelegate?.didSelectItem(with: productVariantId, at: index)
    }
}
