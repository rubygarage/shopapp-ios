//
//  LastArrivalsViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class LastArrivalsViewModel: GridCollectionViewModel {
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
        Repository.shared.getProductList(paginationValue: paginationValue, sortBy: SortingValue.createdAt, reverse: true) { [weak self] (products, error) in
            if let error = error {
                self?.state.onNext((state: .error, error: error))
            }
            if let productsArray = products {
                self?.updateProducts(products: productsArray)
                self?.state.onNext((state: .content, error: nil))
            }
            self?.canLoadMore = products?.count ?? 0 == kItemsPerPage
        }
    }
    
    private func updateProducts(products: [Product]) {
        if paginationValue == nil {
            self.products.value.removeAll()
        }
        self.products.value += products
    }
}
