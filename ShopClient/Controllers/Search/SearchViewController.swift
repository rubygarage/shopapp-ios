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
    
    var searchPhrase = String()
    
    override func viewDidLoad() {
        viewModel = SearchViewModel()
        super.viewDidLoad()
        
        setupSearchBar()
        reloadRemoteData()
    }
    
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchControllerDelegate = SearchViewControllerDelegate(delegate: self)
        searchController?.searchBar.delegate = searchControllerDelegate
        
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = false
        
        navigationItem.titleView = searchController?.searchBar
        
        definesPresentationContext = true
    }
    
    private func reloadRemoteData() {
        viewModel.paginationValue = nil
        loadRemoteData()
    }
    
    private func loadNextPage() {
        viewModel.paginationValue = viewModel.products.value.last?.paginationValue
        loadRemoteData()
    }
    
    private func loadRemoteData() {
        Repository.shared.searchProducts(paginationValue: viewModel.paginationValue, searchQuery: searchPhrase) { [weak self] (products, error) in
            if let productsArray = products {
                self?.updateProducts(products: productsArray, needToClear: self?.viewModel.paginationValue == nil)
            }
            self?.viewModel.canLoadMore = products?.count ?? 0 == kItemsPerPage
            self?.stopLoadAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    private func updateProducts(products: [Product], needToClear: Bool) {
        if needToClear {
            self.viewModel.products.value.removeAll()
        }
        self.viewModel.products.value += products
    }
    
    // MARK: - overriding
    override func pullToRefreshHandler() {
        reloadRemoteData()
    }
    
    override func infinityScrollHandler() {
        loadNextPage()
    }
    
    // MARK: - SearchViewControllerDelegateProtocol
    func didTapSearch(with text: String) {
        searchPhrase = text
        loadRemoteData()
    }
}
