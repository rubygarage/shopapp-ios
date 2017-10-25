//
//  LastArrivalsViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class LastArrivalsViewController: GridCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        loadRemoteData()
    }
    
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.LastArrivals", comment: String())
    }
    
    // MARK: - remote
    private func loadRemoteData() {
        RepositoryRepo.shared.getProductList(perPage: kItemsPerPage, paginationValue: paginationValue, sortBy: SortingValue.createdAt, reverse: true) { [weak self] (products, error) in
            if let productsArray = products {
                self?.updateProducts(products: productsArray)
            }
            self?.canLoadMore = products?.count ?? 0 == kItemsPerPage
            self?.stopLoadAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - private
    private func updateProducts(products: [Product]) {
        if paginationValue == nil {
            self.products.removeAll()
        }
        self.products += products
    }
    
    // MARK: - ovarriding
    override func pullToRefreshHandler() {
        paginationValue = nil
        loadRemoteData()
    }
    
    override func infinityScrollHandler() {
        paginationValue = products.last?.paginationValue
        loadRemoteData()
    }
}
