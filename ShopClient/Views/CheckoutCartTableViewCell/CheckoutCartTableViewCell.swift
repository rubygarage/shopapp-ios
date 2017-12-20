//
//  CheckoutCartTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutCartTableViewCell: UITableViewCell, CheckoutCartCollectionDataSourceDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cartProducts: [CartProduct]!
    var collectionDataSource: CheckoutCartCollectionDataSource!
    var collectionDelegate: CheckoutCartCollectionDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    public func configure(with items: [CartProduct]) {
        cartProducts = items
        setupCollectionView()
    }
    
    // MARK: - private
    private func setupCollectionView() {
        let cartNib = UINib(nibName: String(describing: CheckoutCartCollectionCell.self), bundle: nil)
        collectionView.register(cartNib, forCellWithReuseIdentifier: String(describing: CheckoutCartCollectionCell.self))
        
        collectionDataSource = CheckoutCartCollectionDataSource(delegate: self)
        collectionView.dataSource = collectionDataSource
        
        collectionDelegate = CheckoutCartCollectionDelegate()
        collectionView.delegate = collectionDelegate
    }
    
    // MARK: - CheckoutCartCollectionDataSourceDelegate
    func itemsCount() -> Int {
        return cartProducts.count
    }
    
    func item(at index: Int) -> CartProduct {
        return cartProducts[index]
    }
}
