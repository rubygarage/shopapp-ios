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
    var keyPhrase: String?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = ProductsListViewModel()
        super.viewDidLoad()

        setupViewModel()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar()
    }
    
    // MARK: - Setup
    
    private func updateNavigationBar() {
        addCartBarButton()
    }
    
    private func setupViewModel() {
        viewModel.sortingValue = sortingValue
        viewModel.keyPhrase = keyPhrase
        
        viewModel.products.asObservable()
            .subscribe(onNext: { [weak self] products in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.stopLoadAnimating()
                strongSelf.collectionProvider.products = products
                strongSelf.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.reloadData()
    }
    
    // MARK: - BasePaginationViewController
    
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
}
