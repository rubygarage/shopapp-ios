//
//  ProductsUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ProductsUseCase {
    private let popuarSectionItemsMaxCount = 4
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func getLastArrivalProducts(_ callback: @escaping ApiCallback<[Product]>) {
        repository.getProducts(perPage: kItemsPerPage, paginationValue: nil, sortBy: .recent, keyword: nil, excludeKeyword: nil, callback: callback)
    }
    
    func getPopularProducts(_ callback: @escaping ApiCallback<[Product]>) {
        repository.getProducts(perPage: popuarSectionItemsMaxCount, paginationValue: nil, sortBy: .relevant, keyword: nil, excludeKeyword: nil, callback: callback)
    }
    
    func getProducts(paginationValue: Any?, sortBy: SortType, keyword: String? = nil, excludeKeyword: String? = nil, _ callback: @escaping ApiCallback<[Product]>) {
        repository.getProducts(perPage: kItemsPerPage, paginationValue: paginationValue, sortBy: sortBy, keyword: keyword, excludeKeyword: excludeKeyword, callback: callback)
    }
    
    func getProducts(paginationValue: Any?, searchPhrase: String, _ callback: @escaping ApiCallback<[Product]>) {
        repository.searchProducts(perPage: kItemsPerPage, paginationValue: paginationValue, query: searchPhrase, callback: callback)
    }
}
