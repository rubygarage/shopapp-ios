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
    
    var images: [Image]!
    var collectionDataSource: CheckoutCartCollectionDataSource!
    var collectionDelegate: CheckoutCartCollectionDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    public func configure(with items: [Image]) {
        images = items
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
        return images.count
    }
    
    func item(at index: Int) -> Image {
        return images[index]
    }
}
