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
    func getProduct(id: String, options: [SelectedOption], callback: @escaping ApiCallback<ProductEntity>) {
        shopAPI?.getProduct(id: id, options: options, callback: callback)
    }
    
    func getProductList(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, sortBy: SortingValue? = nil, reverse: Bool = false, callback: @escaping ApiCallback<[ProductEntity]>) {
        shopAPI?.getProductList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse, callback: callback)
    }
    
    func searchProducts(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, searchQuery: String, callback: @escaping ApiCallback<[ProductEntity]>) {
        shopAPI?.searchProducts(perPage: perPage, paginationValue: paginationValue, searchQuery: searchQuery, callback: callback)
    }
    
    func getCategoryList(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, sortBy: SortingValue? = nil, reverse: Bool = false, callback: @escaping ApiCallback<[CategoryEntity]>) {
        shopAPI?.getCategoryList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse, callback: callback)
    }
    
    func getCategoryDetails(id: String, perPage: Int = kItemsPerPage, paginationValue: Any? = nil, sortBy: SortingValue? = nil, reverse: Bool = false, callback: @escaping ApiCallback<CategoryEntity>) {
        shopAPI?.getCategoryDetails(id: id, perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse, callback: callback)
    }
    
    func getArticleList(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, sortBy: SortingValue? = nil, reverse: Bool = false, callback: @escaping ApiCallback<[Article]>) {
        shopAPI?.getArticleList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse, callback: callback)
    }
}
