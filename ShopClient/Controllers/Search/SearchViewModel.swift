//
//  SearchViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SearchViewModel: GridCollectionViewModel {
    var searchPhrase = Variable<String>(String())
    var categories = PublishSubject<[Category]>()
    
    public func reloadData() {
        paginationValue = nil
        loadRemoteData()
    }
    
    public func loadNextPage() {
        paginationValue = products.value.last?.paginationValue
        loadRemoteData()
    }
    
    public func loadCategories() {
        state.onNext(.loading(showHud: true))
        Repository.shared.getCategoryList { [weak self] (catogories, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let categories = catogories {
                self?.categories.onNext(categories)
                self?.state.onNext(.content)
            }
        }
    }
    
    public func clearResult() {
        products.value.removeAll()
    }
    
    private func loadRemoteData() {
        let showHud = products.value.count == 0
        state.onNext(.loading(showHud: showHud))
        Repository.shared.searchProducts(paginationValue: paginationValue, searchQuery: searchPhrase.value) { [weak self] (products, error) in
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
