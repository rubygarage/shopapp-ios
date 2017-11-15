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
        state.onNext(.loading)
        Repository.shared.getProductList(paginationValue: paginationValue, sortBy: SortingValue.createdAt, reverse: true) { [weak self] (products, error) in
            if let error = error {
                self?.state.onNext(.error(error))
            }
            if let productsArray = products {
                self?.updateProducts(products: productsArray)
                self?.state.onNext(.content)
            }
            self?.canLoadMore = products?.count ?? 0 == kItemsPerPage
        }
    }
}
