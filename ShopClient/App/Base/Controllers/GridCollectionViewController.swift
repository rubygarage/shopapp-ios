//
//  GridViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import UIScrollView_InfiniteScroll

class GridCollectionViewController<T: GridCollectionViewModel>: BaseCollectionViewController<T>, GridCollectionDelegateProtocol {
    private var collectionDataSource: GridCollectionDataSource!
    // swiftlint:disable weak_delegate
    private var collectionDelegate: GridCollectionDelegate!
    // swiftlint:enable weak_delegate
    
    var selectedProduct: Product?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            productDetailsViewController.productId = selectedProduct!.id
        }
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: GridCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: GridCollectionViewCell.self))
        
        collectionDataSource = GridCollectionDataSource()
        collectionDataSource.delegate = self
        collectionView.dataSource = collectionDataSource
        
        collectionDelegate = GridCollectionDelegate()
        collectionDelegate.delegate = self
        collectionView.delegate = collectionDelegate
        
        collectionView.contentInset = GridCollectionViewCell.collectionViewInsets
    }
    
    // MARK: - GridCollectionDelegateProtocol
    
    func didSelectItem(at index: Int) {
        if index < viewModel.products.value.count {
            selectedProduct = viewModel.products.value[index]
            performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
        }
    }
}

// MARK: - GridCollectionDataSourceProtocol

extension GridCollectionViewController: GridCollectionDataSourceProtocol {
    func numberOfItems() -> Int {
        return viewModel.products.value.count
    }
    
    func item(for indexPath: IndexPath) -> Product {
        return viewModel.products.value[indexPath.row]
    }
}
