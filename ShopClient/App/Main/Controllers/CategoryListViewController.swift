//
//  CategoryListViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class CategoryListViewController: BaseCollectionViewController<CategoryListViewModel> {
    private var collectionProvider: CategoryListCollectionProvider!
    
    fileprivate var selectedCategory: Category?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = CategoryListViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
        loadData()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
         let cellName = String(describing: CategoryCollectionViewCell.self)
         let nib = UINib(nibName: cellName, bundle: nil)
         collectionView.register(nib, forCellWithReuseIdentifier: cellName)
         
         collectionProvider = CategoryListCollectionProvider()
         //collectionProvider.delegate = self
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

/*
 // MARK: - SearchCollectionProviderDelegate
 
 extension SearchViewController: SearchCollectionProviderDelegate {
 func provider(_ provider: SearchCollectionProvider, didSelect category: Category) {
 selectedCategory = category
 performSegue(withIdentifier: SegueIdentifiers.toCategory, sender: self)
 }
 }
 */
