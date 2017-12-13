//
//  ProductsListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ProductsListViewController: GridCollectionViewController<ProductsListViewModel> {
    var sortingValue: SortingValue!
    
    override func viewDidLoad() {
        viewModel = ProductsListViewModel()
        viewModel.sortingValue = sortingValue
        super.viewDidLoad()

        setupViewModel()
        loadData()
    }
    
    // MARK: - private
    private func setupViewModel() {
        viewModel.products.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.stopLoadAnimating()
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.reloadData()
    }
    
    // MARK: - ovarriding
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        loadData()
    }
}
