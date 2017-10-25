//
//  SearchViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class SearchViewController: GridCollectionViewController, SearchViewControllerDelegateProtocol {
    
    var searchController: UISearchController?
    var searchControllerDelegate: SearchViewControllerDelegate?
    
    var searchPhrase = String()
    
    override func viewDidLoad() {
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
        paginationValue = nil
        loadRemoteData()
    }
    
    private func loadNextPage() {
        paginationValue = products.last?.paginationValue
        loadRemoteData()
    }
    
    private func loadRemoteData() {
        Repository.shared.searchProducts(paginationValue: paginationValue, searchQuery: searchPhrase) { [weak self] (products, error) in
            if let productsArray = products {
                self?.updateProducts(products: productsArray, needToClear: self?.paginationValue == nil)
            }
            self?.canLoadMore = products?.count ?? 0 == kItemsPerPage
            self?.stopLoadAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    private func updateProducts(products: [Product], needToClear: Bool) {
        if needToClear {
            self.products.removeAll()
        }
        self.products += products
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
