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
    var products = [Product]()
    
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
    
    // MARK: - override
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
    
    // MARK: - GridCollectionDataSourceProtocol
    func numberOfItems() -> Int {
        return products.count
    }
    
    func item(for indexPath: IndexPath) -> Product {
        return products[indexPath.row]
    }
    
    // MARK: - GridCollectionDelegateProtocol
    func didSelectItem(at index: Int) {
        if index < products.count {
            let product = products[index]
            pushDetailController(with: product)
        }
    }
}
