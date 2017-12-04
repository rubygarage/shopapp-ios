//
//  GridViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class GridCollectionViewController<T: GridCollectionViewModel>: BaseCollectionViewController<T>, GridCollectionDataSourceProtocol, GridCollectionDelegateProtocol {
    
    var collectionDataSource: GridCollectionDataSource?
    var collectionDelegate: GridCollectionDelegate?
    
    // MARK: - view controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    // MARK: - setup
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: GridCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: GridCollectionViewCell.self))
        
        collectionDataSource = GridCollectionDataSource(delegate: self)
        collectionView.dataSource = collectionDataSource
        
        collectionDelegate = GridCollectionDelegate(delegate: self)
        collectionView.delegate = collectionDelegate
    }
    
    // MARK: - GridCollectionDataSourceProtocol
    func numberOfItems() -> Int {
        return viewModel.products.value.count
    }
    
    func item(for indexPath: IndexPath) -> Product {
        return viewModel.products.value[indexPath.row]
    }
    
    // MARK: - GridCollectionDelegateProtocol
    func didSelectItem(at index: Int) {
        if index < viewModel.products.value.count {
            let product = viewModel.products.value[index]
            pushDetailController(with: product)
        }
    }
}
