//
//  CategoryViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CategoryViewController: GridCollectionViewController<CategoryViewModel>, SortModalControllerProtocol {
    var categoryId = String()
    var categoryTitle = String()
    var category: Category?
    var selectedSortingValue = SortingValue.createdAt
    
    override func viewDidLoad() {
        viewModel = CategoryViewModel()
        super.viewDidLoad()
        
        setupViews()
        loadRemoteData()
    }
    
    // MARK: - setup
    private func setupViews() {
        title = categoryTitle
        addRightBarButton(with: ImageName.sort, action: #selector(CategoryViewController.sortTapHandler))
    }
    
    // MARK: - private
    private func updateData(category: Category) {
        self.category = category
        if let items = category.products {
            updateProducts(products: items)
            canLoadMore = products.count == kItemsPerPage
        }
    }
    
    private func updateProducts(products: [Product]) {
        if paginationValue == nil {
            self.products.removeAll()
        }
        self.products += products
    }
    
    // MARK: - private
    private func loadRemoteData() {
        let reverse = selectedSortingValue == .createdAt
        Repository.shared.getCategoryDetails(id: categoryId, paginationValue: paginationValue, sortBy: selectedSortingValue, reverse: reverse) { [weak self] (result, error) in
            self?.stopLoadAnimating()
            if let category = result {
                self?.updateData(category: category)
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - actions
    func sortTapHandler() {
        let selectedValueString = SortingValue.allValues[selectedSortingValue.rawValue]
        showCategorySortingController(with: SortingValue.allValues, selectedItem: selectedValueString, delegate: self)
    }
    
    // MARK: - overriding
    override func pullToRefreshHandler() {
        paginationValue = nil
        loadRemoteData()
    }
    
    override func infinityScrollHandler() {
        paginationValue = products.last?.paginationValue
        loadRemoteData()
    }
    
    // MARK: - SortModalControllerProtocol
    func didSelect(item: String) {
        if let index = SortingValue.allValues.index(of: item) {
            selectedSortingValue = SortingValue(rawValue: index) ?? selectedSortingValue
            paginationValue = nil
            let indexPath = IndexPath(row: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
            loadRemoteData()
        }
    }
}
