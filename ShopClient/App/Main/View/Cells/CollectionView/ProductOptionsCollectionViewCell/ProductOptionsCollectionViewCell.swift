//
//  ProductOptionsCollectionViewCell.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ProductOptionsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: ProductOptionCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: ProductOptionCollectionViewCell.self))
        
//        dataSource = LastArrivalsTableDataSource(delegate: self)
//        collectionView.dataSource = dataSource
//        
//        delegate = LastArrivalsTableDelegate(delegate: self)
//        collectionView.delegate = delegate
    }
}
