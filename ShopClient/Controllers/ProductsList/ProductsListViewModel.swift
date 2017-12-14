//
//  ProductsListViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class ProductsListViewModel: GridCollectionViewModel {
    var sortingValue: SortingValue!
    
    public func reloadData() {
        paginationValue = nil
        loadRemoteData()
    }
    
    public func loadNextPage() {
        paginationValue = products.value.last?.paginationValue
        loadRemoteData()
    }
    
    private func loadRemoteData() {
        let showHud = products.value.count == 0
        state.onNext(.loading(showHud: showHud))
        let reverse = sortingValue == .createdAt
        Repository.shared.getProductList(paginationValue: paginationValue, sortBy: sortingValue, reverse: reverse) { [weak self] (products, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let productsArray = products {
                self?.updateProducts(products: productsArray)
                self?.state.onNext(.content)
            }
            self?.canLoadMore = products?.count ?? 0 == kItemsPerPage
        }
    }
}
