//
//  ShopCoreAPI.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 8/30/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ShopCoreAPI {
    
    // MARK: - singleton
    static let shared = ShopCoreAPI()
    var shopAPI: ShopAPIProtocol?
    
    // MARK: - setup
    func setup(shopAPI: ShopAPIProtocol) {
        self.shopAPI = shopAPI
    }
    
    // MARK: - user methods
    func getShopInfo(callback: @escaping ApiCallback<Shop>) {
        shopAPI?.getShopInfo(callback: callback)
    }
    
    func getProduct(id: String, callback: @escaping ApiCallback<Product>) {
        shopAPI?.getProduct(id: id, callback: callback)
    }
    
    func getProductList(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, sortBy: SortingValue? = nil, reverse: Bool = false, callback: @escaping ApiCallback<[Product]>) {
        shopAPI?.getProductList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse, callback: callback)
    }
    
    func searchProducts(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, searchQuery: String, callback: @escaping ApiCallback<[Product]>) {
        shopAPI?.searchProducts(perPage: perPage, paginationValue: paginationValue, searchQuery: searchQuery, callback: callback)
    }
    
    func getCategoryList(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, sortBy: SortingValue? = nil, reverse: Bool = false, callback: @escaping ApiCallback<[Category]>) {
        shopAPI?.getCategoryList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse, callback: callback)
    }
    
    func getCategoryDetails(id: String, perPage: Int = kItemsPerPage, paginationValue: Any? = nil, callback: @escaping ApiCallback<Category>) {
        shopAPI?.getCategoryDetails(id: id, perPage: perPage, paginationValue: paginationValue, callback: callback)
    }
    
    func getArticleList(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, sortBy: SortingValue? = nil, reverse: Bool = false, callback: @escaping ApiCallback<[Article]>) {
        shopAPI?.getArticleList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse, callback: callback)
    }
}
