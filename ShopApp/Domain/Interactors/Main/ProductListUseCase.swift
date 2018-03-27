//
//  ProductUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

private let kPopuarSectionItemsMaxCount = 4

class ProductListUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func getLastArrivalProductList(_ callback: @escaping RepoCallback<[Product]>) {
        repository.getProductList(perPage: kItemsPerPage, paginationValue: nil, sortBy: SortingValue.createdAt, keyPhrase: nil, excludePhrase: nil, reverse: true, callback: callback)
    }
    
    func getPopularProductList(_ callback: @escaping RepoCallback<[Product]>) {
        repository.getProductList(perPage: kPopuarSectionItemsMaxCount, paginationValue: nil, sortBy: SortingValue.popular, keyPhrase: nil, excludePhrase: nil, reverse: false, callback: callback)
    }
    
    func getProductList(with paginationValue: Any?, sortingValue: SortingValue, keyPhrase: String? = nil, excludePhrase: String? = nil, reverse: Bool, _ callback: @escaping RepoCallback<[Product]>) {
        repository.getProductList(perPage: kItemsPerPage, paginationValue: paginationValue, sortBy: sortingValue, keyPhrase: keyPhrase, excludePhrase: excludePhrase, reverse: reverse, callback: callback)
    }
    
    func getProductList(with paginationValue: Any?, searchPhrase: String, _ callback: @escaping RepoCallback<[Product]>) {
        repository.searchProducts(perPage: kItemsPerPage, paginationValue: paginationValue, searchQuery: searchPhrase, callback: callback)
    }
}
