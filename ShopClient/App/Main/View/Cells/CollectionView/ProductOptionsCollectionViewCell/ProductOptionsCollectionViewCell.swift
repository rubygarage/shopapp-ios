//
//  ProductOptionsCollectionViewCell.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ProductOptionsCollectionViewCell: UICollectionViewCell {//, ProductOptionCollectionDataSourceProtocol, ProductOptionCollectionDelegateProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: ProductOptionCollectionDataSource?
    private var delegate: ProductOptionCollectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: ProductOptionCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: ProductOptionCollectionViewCell.self))
        /*
        dataSource = ProductOptionCollectionDataSource(delegate: self)
        collectionView.dataSource = dataSource
        
        delegate = ProductOptionCollectionDelegate(delegate: self)
        collectionView.delegate = delegate
 */
    }
}
