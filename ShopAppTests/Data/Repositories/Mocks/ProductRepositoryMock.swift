//
//  ProductRepositoryMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ProductRepositoryMock: ProductRepository {
    var isNeedToReturnError = false
    var isGetProductListStarted = false
    var isGetProductStarted = false
    var isSearchProductsStarted = false
    var isGetProductVariantListStarted = false
    var perPage: Int?
    var paginationValue: String?
    var sortBy: SortType?
    var keyword: String?
    var excludeKeyword: String?
    var id: String?
    var query: String?
    var ids: [String]?
    
    func getProducts(perPage: Int, paginationValue: Any?, sortBy: SortType?, keyword: String?, excludeKeyword: String?, callback: @escaping ApiCallback<[Product]>) {
        isGetProductListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.keyword = keyword
        self.excludeKeyword = excludeKeyword
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func getProduct(id: String, callback: @escaping ApiCallback<Product>) {
        isGetProductStarted = true
        
        self.id = id
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.productWithoutAlternativePrice, nil)
    }
    
    func searchProducts(perPage: Int, paginationValue: Any?, query: String, callback: @escaping ApiCallback<[Product]>) {
        isSearchProductsStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.query = query
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func getProductVariants(ids: [String], callback: @escaping ApiCallback<[ProductVariant]>) {
        isGetProductVariantListStarted = true
        
        self.ids = ids
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
}
