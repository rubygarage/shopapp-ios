//
//  LastArrivalsViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class LastArrivalsViewController: GridCollectionViewController<LastArrivalsViewModel> {

    override func viewDidLoad() {
        viewModel = LastArrivalsViewModel()
        super.viewDidLoad()

        setupViews()
        loadRemoteData()
    }
    
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.LastArrivals", comment: String())
    }
    
    // MARK: - remote
    private func loadRemoteData() {
        Repository.shared.getProductList(perPage: kItemsPerPage, paginationValue: viewModel.paginationValue, sortBy: SortingValue.createdAt, reverse: true) { [weak self] (products, error) in
            if let productsArray = products {
                self?.updateProducts(products: productsArray)
            }
            self?.viewModel.canLoadMore = products?.count ?? 0 == kItemsPerPage
            self?.stopLoadAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - private
    private func updateProducts(products: [Product]) {
        if viewModel.paginationValue == nil {
            self.viewModel.products.value.removeAll()
        }
        self.viewModel.products.value += products
    }
    
    // MARK: - ovarriding
    override func pullToRefreshHandler() {
        viewModel.paginationValue = nil
        loadRemoteData()
    }
    
    override func infinityScrollHandler() {
        viewModel.paginationValue = viewModel.products.value.last?.paginationValue
        loadRemoteData()
    }
}
