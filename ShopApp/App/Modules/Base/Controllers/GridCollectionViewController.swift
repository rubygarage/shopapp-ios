//
//  GridViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway
import UIScrollView_InfiniteScroll

class GridCollectionViewController<T: GridCollectionViewModel>: BaseCollectionViewController<T>, GridCollectionProviderDelegate {
    private(set) var collectionProvider: GridCollectionProvider!
    
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
        collectionView.registerNibForCell(GridCollectionViewCell.self)

        collectionProvider = GridCollectionProvider()
        collectionProvider.delegate = self
        collectionView.dataSource = collectionProvider
        collectionView.delegate = collectionProvider
        
        collectionView.contentInset = GridCollectionViewCell.defaultCollectionViewInsets
    }
    
    // MARK: - GridCollectionProviderDelegate
    
    func provider(_ provider: GridCollectionProvider, didSelect product: Product) {
        selectedProduct = product
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
    
    func provider(_ provider: GridCollectionProvider, didScroll scrollView: UIScrollView) {
    }
}
