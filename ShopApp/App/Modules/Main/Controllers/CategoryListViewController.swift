//
//  CategoryListViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol CategoryListControllerDelegate: class {
    func viewController(_ viewController: CategoryListViewController, didSelect category: ShopApp_Gateway.Category)
}

class CategoryListViewController: BaseCollectionViewController<CategoryListViewModel> {
    private var collectionProvider: CategoryListCollectionProvider!
    
    weak var delegate: CategoryListControllerDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
        loadData()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        collectionView.registerNibForCell(CategoryCollectionViewCell.self)
         
        collectionProvider = CategoryListCollectionProvider()
        collectionProvider.delegate = self
        collectionView.dataSource = collectionProvider
        collectionView.delegate = collectionProvider
        collectionView.contentInset = CategoryCollectionViewCell.collectionViewInsets
    }
    
    private func setupViewModel() {
        viewModel.items.asObservable()
            .subscribe(onNext: { [weak self] categories in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.stopLoadAnimating()
                strongSelf.collectionProvider.categories = categories
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

// MARK: - SearchCollectionProviderDelegate

extension CategoryListViewController: CategoryListCollectionProviderDelegate {
    func provider(_ provider: CategoryListCollectionProvider, didSelect category: ShopApp_Gateway.Category) {
        delegate?.viewController(self, didSelect: category)
    }
}
