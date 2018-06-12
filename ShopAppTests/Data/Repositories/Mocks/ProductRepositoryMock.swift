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
    
    func getProducts(perPage: Int, paginationValue: Any?, sortBy: SortType?, keyword: String?, excludeKeyword: String?, callback: @escaping RepoCallback<[Product]>) {
        isGetProductListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.keyword = keyword
        self.excludeKeyword = excludeKeyword
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getProduct(id: String, callback: @escaping RepoCallback<Product>) {
        isGetProductStarted = true
        
        self.id = id
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Product(), nil)
    }
    
    func searchProducts(perPage: Int, paginationValue: Any?, query: String, callback: @escaping RepoCallback<[Product]>) {
        isSearchProductsStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.query = query
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getProductVariants(ids: [String], callback: @escaping RepoCallback<[ProductVariant]>) {
        isGetProductVariantListStarted = true
        
        self.ids = ids
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
}
