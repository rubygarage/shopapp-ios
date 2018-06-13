//
//  ProductUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ProductListUseCase {
    private let popuarSectionItemsMaxCount = 4
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func getLastArrivalProducts(_ callback: @escaping RepoCallback<[Product]>) {
        repository.getProducts(perPage: kItemsPerPage, paginationValue: nil, sortBy: SortType.createdAt, keyword: nil, excludeKeyword: nil, callback: callback)
    }
    
    func getPopularProducts(_ callback: @escaping RepoCallback<[Product]>) {
        repository.getProducts(perPage: popuarSectionItemsMaxCount, paginationValue: nil, sortBy: SortType.popular, keyword: nil, excludeKeyword: nil, callback: callback)
    }
    
    func getProducts(with paginationValue: Any?, sortBy: SortType, keyword: String? = nil, excludeKeyword: String? = nil, _ callback: @escaping RepoCallback<[Product]>) {
        repository.getProducts(perPage: kItemsPerPage, paginationValue: paginationValue, sortBy: sortBy, keyword: keyword, excludeKeyword: excludeKeyword, callback: callback)
    }
    
    func getProducts(with paginationValue: Any?, searchPhrase: String, _ callback: @escaping RepoCallback<[Product]>) {
        repository.searchProducts(perPage: kItemsPerPage, paginationValue: paginationValue, query: searchPhrase, callback: callback)
    }
}
