//
//  ProductRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

extension ShopifyRepository: ProductRepository {
    public func getProductList(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, sortBy: SortingValue? = nil, keyPhrase: String? = nil, excludePhrase: String? = nil, reverse: Bool = false, callback: @escaping RepoCallback<[Product]>) {
        api.getProductList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, keyPhrase: keyPhrase, excludePhrase: excludePhrase, reverse: reverse, callback: callback)
    }
    
    public func getProduct(id: String, callback: @escaping RepoCallback<Product>) {
        api.getProduct(id: id, callback: callback)
    }
    
    public func searchProducts(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, searchQuery: String, callback: @escaping RepoCallback<[Product]>) {
        api.searchProducts(perPage: perPage, paginationValue: paginationValue, searchQuery: searchQuery, callback: callback)
    }
}
