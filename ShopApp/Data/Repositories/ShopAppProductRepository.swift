//
//  ShopAppProductRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

public class ShopAppProductRepository: ProductRepository {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    public func getProductList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, keyPhrase: String?, excludePhrase: String?, reverse: Bool, callback: @escaping RepoCallback<[Product]>) {
        api.getProductList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, keyPhrase: keyPhrase, excludePhrase: excludePhrase, reverse: reverse, callback: callback)
    }
    
    public func getProduct(id: String, callback: @escaping RepoCallback<Product>) {
        api.getProduct(id: id, callback: callback)
    }
    
    public func searchProducts(perPage: Int, paginationValue: Any?, searchQuery: String, callback: @escaping RepoCallback<[Product]>) {
        api.searchProducts(perPage: perPage, paginationValue: paginationValue, searchQuery: searchQuery, callback: callback)
    }
    
    public func getProductVariantList(ids: [String], callback: @escaping RepoCallback<[ProductVariant]>) {
        api.getProductVariantList(ids: ids, callback: callback)
    }
}
