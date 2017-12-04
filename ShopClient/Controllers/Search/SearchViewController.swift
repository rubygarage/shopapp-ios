//
//  SearchViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class SearchViewController: GridCollectionViewController<SearchViewModel>, SearchViewControllerDelegateProtocol {
    
    var searchController: UISearchController?
    var searchControllerDelegate: SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        viewModel = SearchViewModel()
        super.viewDidLoad()
        
        setupViewModel()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar()
    }
    
    private func updateNavigationBar() {
        setupSearchBar()
        setupBarItems()
    }
    
    private func setupBarItems() {
        Repository.shared.getCartProductList { [weak self] (products, error) in
            let cartItemsCount = products?.count ?? 0
            self?.addCartBarButton(with: cartItemsCount)
        }
    }
    
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchControllerDelegate = SearchViewControllerDelegate(delegate: self)
        searchController?.searchBar.delegate = searchControllerDelegate
        
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = false
        
        tabBarController?.navigationItem.titleView = searchController?.searchBar
        
        definesPresentationContext = true
    }
    
    private func setupViewModel() {
        searchController?.searchBar.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.searchPhrase)
            .disposed(by: disposeBag)
        
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
    
    // MARK: - overriding
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
    
    // MARK: - SearchViewControllerDelegateProtocol
    func didTapSearch() {
        viewModel.reloadData()
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        loadData()
    }
}
