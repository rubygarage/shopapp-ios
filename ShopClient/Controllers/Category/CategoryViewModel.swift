//
//  CategoryViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CategoryViewModel: GridCollectionViewModel {
    var categoryId = String()
    var selectedSortingValue = SortingValue.createdAt
    
    public func reloadData() {
        paginationValue = nil
        loadRemoteData()
    }
    
    public func loadNextPage() {
        paginationValue = products.value.last?.paginationValue
        loadRemoteData()
    }
    
    private func loadRemoteData() {
        state.onNext((state: .loading, error: nil))
        let reverse = selectedSortingValue == .createdAt
        Repository.shared.getCategoryDetails(id: categoryId, paginationValue: paginationValue, sortBy: selectedSortingValue, reverse: reverse) { [weak self] (result, error) in
            if let error = error {
                self?.state.onNext((state: .error, error: error))
            }
            if let category = result {
                self?.updateData(category: category)
                self?.state.onNext((state: .content, error: nil))
            }
            self?.canLoadMore = result?.products?.count ?? 0 == kItemsPerPage
        }
    }
    
    // MARK: - private
    private func updateData(category: Category) {
        if let items = category.products {
            updateProducts(products: items)
            canLoadMore = products.value.count == kItemsPerPage
        }
    }
}
