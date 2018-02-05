//
//  GridViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

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
        let cellName = String(describing: GridCollectionViewCell.self)
        let nib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellName)
        
        collectionProvider = GridCollectionProvider()
        collectionProvider.delegate = self
        collectionView.dataSource = collectionProvider
        collectionView.delegate = collectionProvider
        
        collectionView.contentInset = GridCollectionViewCell.collectionViewInsets
    }
    
    // MARK: - GridCollectionProviderDelegate
    
    func provider(_ provider: GridCollectionProvider, didSelect product: Product) {
        selectedProduct = product
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
    
    func provider(_ provider: GridCollectionProvider, didScroll scrollView: UIScrollView) {
    }
}
